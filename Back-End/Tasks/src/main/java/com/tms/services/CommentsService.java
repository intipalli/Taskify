package com.tms.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CommentsService {

	private static final Logger logger = LoggerFactory.getLogger(CommentsService.class);

	// Function to add comments to task history.
	public JSONObject addComments(JSONObject input) {
		JSONObject response = new JSONObject();
		String querySelectStatus = "SELECT CurrentTaskStatus FROM task WHERE UserId=? AND Id=?";
		String queryInsertHistory = "INSERT INTO UserTaskHistory(Comments, TaskStatus, DateTime, UserId, TaskId) VALUES(?,?,?,?,?)";

		try (Connection conn = DatabaseManager.getConnection();
				PreparedStatement psSelectStatus = conn.prepareStatement(querySelectStatus);
				PreparedStatement psInsertHistory = conn.prepareStatement(queryInsertHistory)) {

			// Retrieve current task status
			psSelectStatus.setInt(1, input.getInt("userId"));
			psSelectStatus.setInt(2, input.getInt("taskId"));
			try (ResultSet rs = psSelectStatus.executeQuery()) {
				String currentTaskStatus = "";
				if (rs.next()) {
					currentTaskStatus = rs.getString("CurrentTaskStatus");
				}

				// Insert into UserTaskHistory
				psInsertHistory.setString(1, input.getString("comments"));
				psInsertHistory.setString(2, currentTaskStatus);
				psInsertHistory.setString(3, Utilities.getCurrentDateTime());
				psInsertHistory.setInt(4, input.getInt("userId"));
				psInsertHistory.setInt(5, input.getInt("taskId"));
				psInsertHistory.executeUpdate();

				response.put("Success", "Comments added successfully");
			}
		} catch (SQLException | JSONException e) {
			e.printStackTrace();
			response.put("Error", "Failed to add comments. See logs for details.");
		}

		return response;
	}

	// Function to edit comments in task history.
	public JSONObject editComments(JSONObject input) {
		JSONObject response = new JSONObject();
		String queryUpdateComments = "UPDATE UserTaskHistory SET Comments=? WHERE UserId=? AND TaskId=? AND `DateTime`=? AND TaskStatus=?";

		try {

			Connection conn = DatabaseManager.getConnection();
			PreparedStatement psUpdateComments = conn.prepareStatement(queryUpdateComments);

			psUpdateComments.setString(1, input.getString("comments"));
			psUpdateComments.setInt(2, input.getInt("userId"));
			psUpdateComments.setInt(3, input.getInt("taskId"));
			psUpdateComments.setString(4, input.getString("dateTime"));
			psUpdateComments.setString(5, input.getString("Status"));

			int rowsUpdated = psUpdateComments.executeUpdate();
			if (rowsUpdated > 0) {
				response.put("taskId", input.getInt("taskId"));
				response.put("Status", "Comments Updated");
			} else {
				response.put("Error", "No rows were updated. Check your input parameters.");
			}
		} catch (Exception e) {
			e.printStackTrace();

		}

		return response;
	}

	// Method to delete a comment.
	public JSONObject deleteComment(JSONObject input) {
		JSONObject response = new JSONObject();
		String queryDeleteComment = "DELETE FROM UserTaskHistory WHERE UserId=? AND TaskId=? AND `DateTime`=? AND TaskStatus=?";

		try (Connection conn = DatabaseManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(queryDeleteComment)) {

			pstmt.setInt(1, input.getInt("userId"));
			pstmt.setInt(2, input.getInt("taskId"));
			pstmt.setString(3, input.getString("dateTime"));
			pstmt.setString(4, input.getString("Status"));

			int rowsAffected = pstmt.executeUpdate();
			if (rowsAffected > 0) {
				response.put("Successful", "Values Deleted");
			} else {
				response.put("Warning", "No matching records found");
			}
		} catch (SQLException | JSONException e) {
			handleSQLException("Error deleting comment", e);
			response.put("Error", "Failed to delete comment. See logs for details.");
		}

		return response;
	}

	// Helper method to handle SQLException
	private void handleSQLException(String message, Exception e) {
		String errorMessage = message + ": " + e.getMessage();
		logger.error(errorMessage, e);
	}
}
