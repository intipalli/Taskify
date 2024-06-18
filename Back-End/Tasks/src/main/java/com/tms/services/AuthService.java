package com.tms.services;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Random;

import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AuthService {

	private static final Logger logger = LoggerFactory.getLogger(AuthService.class);

	public JSONObject login(JSONObject login) throws JSONException, SQLException {
		JSONObject response = new JSONObject();
		String query = "SELECT Id, UserName, FirstName, LastName, Email, Mobile, RoleId FROM tmsusers WHERE UserName = ? AND Password = ?";
		try (Connection conn = DatabaseManager.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
			ps.setString(1, login.getString("userName"));
			ps.setString(2, login.getString("password"));

			try (ResultSet rs = ps.executeQuery()) {
				int userId = 0;
				int roleId = 0;

				if (rs.next()) {
					userId = rs.getInt("Id");
					response.put("id", userId);
					response.put("firstName", rs.getString("FirstName"));
					response.put("lastName", rs.getString("LastName"));
					response.put("email", rs.getString("Email"));
					response.put("username", rs.getString("UserName"));
					response.put("mobile", rs.getString("Mobile"));
					roleId = rs.getInt("RoleId");
				}

				query = "SELECT Token FROM tmsusertoken WHERE UserId = ?";
				try (PreparedStatement psToken = conn.prepareStatement(query)) {
					psToken.setInt(1, userId);

					try (ResultSet rsToken = psToken.executeQuery()) {
						if (rsToken.next()) {
							response.put("token", rsToken.getString("Token"));
						}
					}
				}

				query = "SELECT name, Status FROM tmsrole WHERE Id = ?";
				try (PreparedStatement psRole = conn.prepareStatement(query)) {
					psRole.setInt(1, roleId);

					try (ResultSet rsRole = psRole.executeQuery()) {
						if (rsRole.next()) {
							response.put("role", rsRole.getString("name"));
							response.put("roleStatus", rsRole.getInt("Status"));
						}
					}
				}
			}
		} catch (SQLException e) {
			logger.error("SQLException occurred during login: {}", e.getMessage());
			throw e;
		} catch (JSONException e) {
			logger.error("JSONException occurred during login: {}", e.getMessage());
			throw e;
		}
		return response;
	}

	public JSONObject forgotPassword(JSONObject newPassword) throws JSONException, SQLException {
		JSONObject response = new JSONObject();

		String oldPassword = "";
		String query = "SELECT Password FROM tmsusers WHERE UserName = ?";
		try (Connection conn = DatabaseManager.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
			ps.setString(1, newPassword.getString("userName"));

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					oldPassword = rs.getString("Password");
				}
			}

			if (!newPassword.getString("newPassword").equals(oldPassword)) {
				query = "UPDATE tmsusers SET Password = ? WHERE UserName = ?";
				try (PreparedStatement psUpdate = conn.prepareStatement(query)) {
					psUpdate.setString(1, newPassword.getString("newPassword"));
					psUpdate.setString(2, newPassword.getString("userName"));
					psUpdate.executeUpdate();
					response.put("success", "Your password has been successfully updated.");
				}
			} else {
				response.put("warning", "New password is the same as the old password");
			}

			query = "SELECT Id, FirstName, LastName FROM tmsusers WHERE UserName = ?";
			try (PreparedStatement psUser = conn.prepareStatement(query)) {
				psUser.setString(1, newPassword.getString("userName"));

				try (ResultSet rsUser = psUser.executeQuery()) {
					if (rsUser.next()) {
						response.put("id", rsUser.getInt("Id"));
						response.put("userName", newPassword.getString("userName"));
						response.put("fullName", rsUser.getString("FirstName") + " " + rsUser.getString("LastName"));
					}
				}
			}
		} catch (SQLException e) {
			logger.error("SQLException occurred during password reset: {}", e.getMessage());
			throw e;
		} catch (JSONException e) {
			logger.error("JSONException occurred during password reset: {}", e.getMessage());
			throw e;
		}
		return response;
	}

	public boolean tokenChecker(String token) throws SQLException {
		boolean response = false;
		String query = "SELECT Id FROM tmsusertoken WHERE Token=?";
		try {
			Connection conn = DatabaseManager.getConnection();
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, token);

			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				response = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Exception occurred during token check: {}", e.getMessage());
			throw e;
		}
		return response;
	}

	public static JSONObject sendOtp(String emailId, String otp) {
		JSONObject response = new JSONObject();
		String subject = "TMS User Validation";
		String body = "Your OTP is: " + otp;

		try {
			Session session = Utilities.getSessionObject();
			if (session == null) {
				response.put("status", "Failed to get email session");
				return response;
			}

			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(Utilities.getPropertyValue("from", "email.properties")));
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(emailId));
			message.setSubject(subject);
			Multipart mp = new MimeMultipart();
			BodyPart bp = new MimeBodyPart();
			bp.setText(body);
			mp.addBodyPart(bp);
			message.setContent(mp);
			Transport.send(message);
			response.put("status", "OTP sent successfully");
		} catch (Exception e) {
			e.printStackTrace();
			try {
				response.put("status", "Error sending OTP");
				response.put("error", e.getMessage());
			} catch (JSONException jsonException) {
				jsonException.printStackTrace();
			}
		}
		return response;
	}

	public JSONObject generateOtp(JSONObject obj) throws JSONException, SQLException, IOException {
		JSONObject response = new JSONObject();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			Connection conn = DatabaseManager.getConnection();
			String query = "SELECT email FROM tmsusers WHERE username=? AND status=1";
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, obj.getString("userName"));
			rs = pstmt.executeQuery();

			String email;
			if (rs.next()) {
				email = rs.getString("email");
			} else {
				response.put("error", "User is deactivated");
				return response;
			}

			Random rndm = new Random();
			int num = rndm.nextInt(999999);
			String otp = String.format("%06d", num);

			String deleteQuery = "DELETE FROM tmsotp WHERE username=?";
			pstmt = conn.prepareStatement(deleteQuery);
			pstmt.setString(1, obj.getString("userName"));
			pstmt.executeUpdate();

			String otpInsertQuery = "INSERT INTO tmsotp(username, email, otp, timeStamp, verificationStatus, retries) VALUES (?, ?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(otpInsertQuery);
			pstmt.setString(1, obj.getString("userName"));
			pstmt.setString(2, email);
			pstmt.setString(3, otp);
			pstmt.setString(4, Utilities.getCurrentDateTime());
			pstmt.setInt(5, 0);
			pstmt.setInt(6, 0);
			pstmt.executeUpdate();

			JSONObject js = sendOtp(email, otp);
			if (js.has("status")) {
				response.put("status", "OTP sent successfully");
			}

		} catch (Exception e) {
			e.printStackTrace();

		}
		return response;
	}

	public JSONObject verifyOtp(JSONObject obj) throws JSONException, SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject response = new JSONObject();

		try (Connection conn = DatabaseManager.getConnection()) {
			String query = "SELECT otp, retries FROM tmsotp WHERE username=? AND verificationStatus=0";
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, obj.getString("userName"));
			rs = pstmt.executeQuery();

			if (rs.next()) {
				String otp = rs.getString("otp");
				int retries = rs.getInt("retries");

				if (otp.equals(obj.getString("otp"))) {
					String updateQuery = "UPDATE tmsotp SET verificationStatus=1 WHERE username=?";
					pstmt = conn.prepareStatement(updateQuery);
					pstmt.setString(1, obj.getString("userName"));
					pstmt.executeUpdate();

					response.put("status", "verified");
				} else {
					retries++;
					String updateRetriesQuery = "UPDATE tmsotp SET retries=? WHERE username=? AND verificationStatus=0";
					pstmt = conn.prepareStatement(updateRetriesQuery);
					pstmt.setInt(1, retries);
					pstmt.setString(2, obj.getString("userName"));
					pstmt.executeUpdate();

					if (retries < 3) {
						response.put("status", "not verified");
						response.put("retriesRemaining", 3 - retries);
					} else {
						String deactivateUserQuery = "UPDATE tmsusers SET status=0 WHERE username=?";
						pstmt = conn.prepareStatement(deactivateUserQuery);
						pstmt.setString(1, obj.getString("userName"));
						pstmt.executeUpdate();

						response.put("error", "User is deactivated");
					}
				}
			} else {
				response.put("error", "Invalid username or OTP");
			}

		} catch (SQLException e) {
			logger.error("SQLException occurred during OTP verification: {}", e.getMessage());
			response.put("error", "Database error occurred: " + e.getMessage());
		} finally {
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
		}
		return response;
	}

}