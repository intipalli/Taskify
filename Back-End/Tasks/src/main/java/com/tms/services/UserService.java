package com.tms.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UserService {

	private static final Logger logger = LoggerFactory.getLogger(UserService.class);

	private CheckService checkService = new CheckService();

	public JSONObject createUser(JSONObject user) throws JSONException {
		JSONObject response = new JSONObject();
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			conn = DatabaseManager.getConnection();
			if (checkService.isEmailValid(user).getBoolean("exists")) {
				response.put("Error", "Email already exists");
				return response;
			}

			if (checkService.checkUsername(user.getString("userName"))) {
				response.put("Error", "Username already exists");
				return response;
			}

			String query = "INSERT INTO tmsusers (UserName, FirstName, LastName, Password, CreatedOn, Status, Email, Mobile, RoleId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 2)";
			ps = conn.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS);
			ps.setString(1, user.getString("userName"));
			ps.setString(2, user.getString("firstName"));
			ps.setString(3, user.getString("lastName"));
			ps.setString(4, user.getString("password"));
			ps.setString(5, Utilities.timeFetcher());
			ps.setInt(6, 1); // Assuming 1 represents active status
			ps.setString(7, user.getString("email"));
			ps.setString(8, user.getString("mobile"));
			ps.executeUpdate();

			// Retrieve generated user ID
			rs = ps.getGeneratedKeys();
			int userId = 0;
			if (rs.next()) {
				userId = rs.getInt(1);
			}

			if (userId > 0) {
				String uuid = UUID.randomUUID().toString().replace("-", "");
				query = "INSERT INTO tmsusertoken (UserId, Token) VALUES (?, ?)";
				ps = conn.prepareStatement(query);
				ps.setInt(1, userId);
				ps.setString(2, uuid);
				ps.executeUpdate();

				response.put("id", userId);
				response.put("userName", user.getString("userName"));
				response.put("firstName", user.getString("firstName"));
				response.put("lastName", user.getString("lastName"));
				response.put("userToken", uuid);
			} else {
				response.put("Error", "Failed to create user");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return response;
	}

	public JSONObject listUsers(String token) {
		JSONObject response = new JSONObject();
		JSONArray array = new JSONArray();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			conn = DatabaseManager.getConnection();

			// Fetch role based on token
			String roleQuery = "SELECT r.name FROM tmsrole r " + "LEFT JOIN tmsusers tmsu ON (tmsu.RoleId = r.Id) "
					+ "LEFT JOIN tmsusertoken tmst ON (tmsu.Id = tmst.UserId) " + "WHERE tmst.Token=?";
			pstmt = conn.prepareStatement(roleQuery);
			pstmt.setString(1, token);
			rs = pstmt.executeQuery();
			String role = "";
			if (rs.next()) {
				role = rs.getString("name");
			}

			if ("admin".equalsIgnoreCase(role)) {
				// Fetch users details
				String usersQuery = "SELECT t.Id, t.UserName, t.FirstName, t.LastName, t.Email, t.Mobile, r.name AS role, t.Status "
						+ "FROM tmsusers t " + "LEFT JOIN tmsrole r ON (r.Id = t.RoleId)";
				pstmt = conn.prepareStatement(usersQuery);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					JSONObject userObj = new JSONObject();
					userObj.put("id", rs.getInt("Id"));
					userObj.put("userName", rs.getString("UserName"));
					userObj.put("firstName", rs.getString("FirstName"));
					userObj.put("lastName", rs.getString("LastName"));
					userObj.put("email", rs.getString("Email"));
					userObj.put("mobile", rs.getString("Mobile"));
					userObj.put("role", rs.getString("role"));
					userObj.put("status", rs.getInt("Status"));
					array.put(userObj);
				}
				response.put("users", array);
			} else {
				response.put("Warning", "Only Admin User has this access");
			}
		} catch (SQLException | JSONException e) {
			logger.error("Error listing users: {}", e.getMessage());
			response.put("Error", "Database error occurred");
		} finally {
			closeResources(conn, pstmt, rs);
		}

		return response;
	}

	public JSONObject setUserStatus(JSONObject input) throws JSONException {
		JSONObject response = new JSONObject();
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			conn = DatabaseManager.getConnection();

			String query = "UPDATE tmsusers SET Status=? WHERE Id=?";
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, input.getInt("status"));
			pstmt.setInt(2, input.getInt("id"));
			int updatedRows = pstmt.executeUpdate();

			if (updatedRows > 0) {
				response.put("id", input.getInt("id"));
				response.put("status", input.getInt("status") == 1 ? "activated" : "inactivated");
				response.put("Success", "Status Updated");
			} else {
				response.put("Error", "Failed to update status for user with id " + input.getInt("id"));
			}
		} catch (SQLException e) {
			logger.error("Error setting user status: {}", e.getMessage());
			response.put("Error", "Database error occurred");
		} finally {
			closeResources(conn, pstmt, null);
		}

		return response;
	}

	public JSONObject getUserStatus(String userName) {
		JSONObject response = new JSONObject();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			conn = DatabaseManager.getConnection();

			String query = "SELECT Status FROM tmsusers WHERE UserName=?";
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, userName);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				int status = rs.getInt("Status");
				response.put("Status", status == 1 ? "Active" : "Inactive");
			} else {
				response.put("Error", "User with username '" + userName + "' not found");
			}
		} catch (SQLException | JSONException e) {
			logger.error("Error getting user status: {}", e.getMessage());
			response.put("Error", "Database error occurred");
		} finally {
			closeResources(conn, pstmt, rs);
		}

		return response;
	}

	public JSONObject editProfile(JSONObject input, String token) throws JSONException {
		JSONObject response = new JSONObject();
		Connection conn = null;
		PreparedStatement ps = null;

		try {
			conn = DatabaseManager.getConnection();

			String query = "UPDATE tmsusers SET FirstName=?, LastName=?, Email=?, Mobile=? WHERE Id=?";
			ps = conn.prepareStatement(query);
			ps.setString(1, input.getString("firstName"));
			ps.setString(2, input.getString("lastName"));
			ps.setString(3, input.getString("email"));
			ps.setString(4, input.getString("phone"));
			ps.setInt(5, input.getInt("userId"));
			ps.executeUpdate();

			response.put("FullName", input.getString("firstName") + " " + input.getString("lastName"));
			response.put("Status", "updated");
		} catch (SQLException e) {
			logger.error("Error editing user profile: {}", e.getMessage());
			response.put("Error", "Database error occurred");
		} finally {
			closeResources(conn, ps, null);
		}

		return response;
	}

	private void closeResources(Connection conn, PreparedStatement pstmt, ResultSet rs) {
		if (rs != null) {
			try {
				rs.close();
			} catch (SQLException e) {
				logger.error("Error closing ResultSet: {}", e.getMessage());
			}
		}
		if (pstmt != null) {
			try {
				pstmt.close();
			} catch (SQLException e) {
				logger.error("Error closing PreparedStatement: {}", e.getMessage());
			}
		}
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
				logger.error("Error closing Connection: {}", e.getMessage());
			}
		}
	}
}
