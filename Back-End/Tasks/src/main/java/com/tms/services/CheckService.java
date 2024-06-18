package com.tms.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CheckService {

	private static final Logger logger = LoggerFactory.getLogger(CheckService.class);

	// Method to check if a username exists in the database.
	public boolean checkUsername(String username) {
		String query = "SELECT UserName FROM tmsusers WHERE UserName = ? LIMIT 1";
		boolean response = false;

		try {
			Connection conn = DatabaseManager.getConnection();
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, username);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				response = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return response;
	}

	// Method to check if the username and password are correct.
	public boolean checkPassword(JSONObject jsonInp) {
		String query = "SELECT Password FROM tmsusers WHERE UserName = ? LIMIT 1";
		boolean response = false;

		try (Connection conn = DatabaseManager.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
			ps.setString(1, jsonInp.getString("userName"));
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					String dbPassword = rs.getString("Password");
					if (jsonInp.getString("password").equals(dbPassword)) {
						response = true;
					}
				}
			}
		} catch (SQLException | JSONException e) {
			String errorMessage = "Error checking password: " + e.getMessage();
			logger.error(errorMessage);
			throw new RuntimeException(errorMessage, e);
		}

		return response;
	}

	// Method to check if the email exists in the database.
	public JSONObject isEmailValid(JSONObject input) {
		JSONObject response = new JSONObject();
		String query = "SELECT tmsusers.Email FROM tmsusers WHERE tmsusers.Email = ?";

		try {
			Connection conn = DatabaseManager.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, input.getString("email"));
			ResultSet rs = pstmt.executeQuery();
			response.put("exists", rs.next());

		} catch (Exception e) {
			e.printStackTrace();
		}

		return response;
	}

	// Method to check if a sprint with given name exists.
	public JSONObject isSprintAvailable(JSONObject input) {
		JSONObject response = new JSONObject();
		String query = "SELECT COUNT(*) AS count FROM Sprint WHERE Name = ?";

		try {
			Connection conn = DatabaseManager.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, input.getString("sprintName"));
			ResultSet rs = pstmt.executeQuery();
			if (rs.next())
				response.put("exists", rs.getInt("count") > 0);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return response;
	}

	// Method to check if a task exists in a sprint.
	public JSONObject isTaskAvailable(JSONObject input) {
		JSONObject response = new JSONObject();
		String query = "SELECT t.Id FROM sprint s " + "LEFT OUTER JOIN UserSprintMapping usm ON (usm.SprintId = s.Id) "
				+ "LEFT OUTER JOIN UserSprintTaskMapping ustm ON (ustm.UserSprintMappingId = usm.Id) "
				+ "LEFT OUTER JOIN task t ON (ustm.TaskId = t.Id) " + "WHERE t.TaskName = ? AND s.Id = ?";

		try (Connection conn = DatabaseManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(query)) {
			pstmt.setString(1, input.getString("taskName"));
			pstmt.setInt(2, input.getInt("sprintId"));
			try (ResultSet rs = pstmt.executeQuery()) {
				response.put("exists", rs.next());
			}
		} catch (SQLException | JSONException e) {
			String errorMessage = "Error checking task availability: " + e.getMessage();
			logger.error(errorMessage);
			response.put("error", errorMessage);
		}

		return response;
	}

	// Method to check if a user's task status is "Completed - In Progress".
	public JSONObject userTaskStatusCheck(JSONObject input) {
		JSONObject response = new JSONObject();
		String query = "SELECT TOP 1 DateTime FROM UserTaskHistory WHERE UserId = ? AND TaskId = ? AND TaskStatus = 'Completed - In Progress'";

		try (Connection conn = DatabaseManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(query)) {
			pstmt.setInt(1, input.getInt("userId"));
			pstmt.setInt(2, input.getInt("taskId"));
			try (ResultSet rs = pstmt.executeQuery()) {
				response.put("Key", rs.next());
			}
		} catch (SQLException | JSONException e) {
			String errorMessage = "Error checking user task status: " + e.getMessage();
			logger.error(errorMessage);
			response.put("error", errorMessage);
		}

		return response;
	}

	public JSONObject sprintCheck(int sprintId) {
		JSONObject response = new JSONObject();
		ArrayList<Integer> usmIdList = new ArrayList<>();
		ArrayList<Integer> taskIdList = new ArrayList<>();
		int count = 0;

		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			Connection conn = DatabaseManager.getConnection(); // Get database connection

			// Retrieve UserSprintMapping IDs for the given sprint
			String query = "SELECT Id FROM UserSprintMapping WHERE SprintId=?";
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, sprintId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				usmIdList.add(rs.getInt("Id"));
			}

			// Retrieve distinct task IDs associated with the UserSprintMapping IDs
			query = "SELECT DISTINCT taskId FROM UserSprintTaskMapping WHERE UserSprintMappingId=?";
			for (int usmId : usmIdList) {
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, usmId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					taskIdList.add(rs.getInt("taskId"));
				}
			}

			// Count the number of tasks
			count = taskIdList.size();

			// Determine if tasks are empty
			if (count == 0) {
				response.put("Empty", "True");
			} else {
				response.put("Empty", "False");
			}

		} catch (SQLException | JSONException e) {
			e.printStackTrace();
		} finally {
			// Close resources in finally block
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}

		return response;
	}

}
