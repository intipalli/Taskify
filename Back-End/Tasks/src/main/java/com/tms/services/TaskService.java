package com.tms.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.LoggerFactory;

public class TaskService {

	private static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(TaskService.class);

	public JSONObject listAllTasks(String token) {
		JSONObject response = new JSONObject();
		JSONArray tasks = new JSONArray();
		int userId = 0;

		String userIdQuery = "SELECT UserId FROM tmsusertoken WHERE Token=?";
		String tasksQuery = "SELECT DISTINCT t.*, s.Id AS sprintId, s.Name AS sprintName " + "FROM task t "
				+ "LEFT OUTER JOIN UserSprintTaskMapping ustm ON (ustm.TaskId=t.Id) "
				+ "LEFT OUTER JOIN UserSprintMapping usm ON (usm.Id=ustm.UserSprintMappingId) "
				+ "LEFT OUTER JOIN sprint s ON (s.Id=usm.SprintId) " + "WHERE t.UserId=?";

		Connection conn = null;
		PreparedStatement userIdStmt = null;
		PreparedStatement tasksStmt = null;
		ResultSet rs = null;

		try {
			conn = DatabaseManager.getConnection();

			// Fetch user ID from token
			userIdStmt = conn.prepareStatement(userIdQuery);
			userIdStmt.setString(1, token);
			rs = userIdStmt.executeQuery();
			if (rs.next()) {
				userId = rs.getInt("UserId");
			}
			rs.close();
			userIdStmt.close();

			// Fetch tasks for the user
			tasksStmt = conn.prepareStatement(tasksQuery);
			tasksStmt.setInt(1, userId);
			rs = tasksStmt.executeQuery();

			while (rs.next()) {
				JSONObject task = new JSONObject();
				task.put("userId", userId);
				task.put("sprintId", rs.getInt("sprintId"));
				task.put("sprintName", rs.getString("sprintName"));
				task.put("id", rs.getInt("Id"));
				task.put("taskName", rs.getString("TaskName"));
				task.put("taskDescription", rs.getString("TaskDescription"));
				task.put("startDateTime", Utilities.timeFormatter(rs.getString("StartDateTime")));
				task.put("endDateTime",
						(rs.getString("EndDateTime") != null ? Utilities.timeFormatter(rs.getString("EndDateTime"))
								: "-"));
				task.put("estimatedTimeOfDelivery", rs.getString("EstimatedTimeOfDelivery"));
				task.put("totalTimeSpent", rs.getInt("TotalTimeSpent"));
				task.put("priority", rs.getString("Priority"));
				task.put("status", rs.getInt("Status"));
				task.put("currentTaskStatus", rs.getString("CurrentTaskStatus"));
				tasks.put(task);
			}
			rs.close();
			tasksStmt.close();

			response.put("tasks", tasks);
		} catch (Exception e) {
			e.printStackTrace();

		}

		return response;
	}

	public JSONObject updateTaskStatus(JSONObject task) {
		JSONObject response = new JSONObject();
		String query = "UPDATE task SET Status = ? WHERE Id = ? AND UserId = ?";
		try (Connection conn = DatabaseManager.getConnection();
				PreparedStatement psUpdate = conn.prepareStatement(query)) {
			psUpdate.setInt(1, task.getInt("Status"));
			psUpdate.setInt(2, task.getInt("taskId"));
			psUpdate.setInt(3, task.getInt("userId"));
			psUpdate.executeUpdate();

			query = "SELECT TaskName, Status FROM task WHERE Id = ?";
			try (PreparedStatement psSelect = conn.prepareStatement(query)) {
				psSelect.setInt(1, task.getInt("taskId"));

				try (ResultSet rs = psSelect.executeQuery()) {
					if (rs.next()) {
						response.put("taskName", rs.getString("TaskName"));
						response.put("Id", task.get("taskId"));
						response.put("status", rs.getInt("Status"));
					}
				}
			}
		} catch (SQLException | JSONException e) {
			LOGGER.error("Error updating task status: {}", e.getMessage());
			response.put("Error", "Failed to update task status");
		}
		return response;
	}

	public JSONObject updateTask(JSONObject updateTask) {
		JSONObject response = new JSONObject();
		String query = "UPDATE task SET TaskName=?, TaskDescription=?, EstimatedTimeOfDelivery=?, Priority=? WHERE Id=?";
		try (Connection conn = DatabaseManager.getConnection();
				PreparedStatement psUpdate = conn.prepareStatement(query)) {
			psUpdate.setString(1, updateTask.getString("taskName"));
			psUpdate.setString(2, updateTask.getString("taskDescription"));
			psUpdate.setInt(3, updateTask.getInt("estimatedTimeOfDelivery"));
			psUpdate.setString(4, updateTask.getString("priority"));
			psUpdate.setInt(5, updateTask.getInt("id"));
			psUpdate.executeUpdate();

			query = "SELECT TaskName FROM task WHERE Id=?";
			try (PreparedStatement psSelect = conn.prepareStatement(query)) {
				psSelect.setInt(1, updateTask.getInt("id"));
				try (ResultSet rs = psSelect.executeQuery()) {
					if (rs.next()) {
						response.put("taskName", rs.getString("TaskName"));
					}
				}
			}
			response.put("id", updateTask.getInt("id"));
		} catch (SQLException | JSONException e) {
			LOGGER.error("Error updating task: {}", e.getMessage());
			response.put("Error", "Failed to update task");
		}
		return response;
	}

	public JSONObject getSpecificTaskHistory(JSONObject input) {
		JSONObject response = new JSONObject();
		JSONArray taskHistory = new JSONArray();

		String query = "SELECT TaskName, TaskDescription FROM task WHERE UserId = ? AND Id = ?";
		try (Connection conn = DatabaseManager.getConnection();
				PreparedStatement psTask = conn.prepareStatement(query)) {
			psTask.setInt(1, input.getInt("userId"));
			psTask.setInt(2, input.getInt("taskId"));

			try (ResultSet rsTask = psTask.executeQuery()) {
				if (rsTask.next()) {
					response.put("taskName", rsTask.getString("TaskName"));
					response.put("taskDescription", rsTask.getString("TaskDescription"));
				}
			}
		} catch (SQLException | JSONException e) {
			e.printStackTrace();
		}

		query = "SELECT DateTime, TaskStatus, Comments FROM UserTaskHistory WHERE UserId = ? AND TaskId = ?";
		try (Connection conn = DatabaseManager.getConnection();
				PreparedStatement psHistory = conn.prepareStatement(query)) {
			psHistory.setInt(1, input.getInt("userId"));
			psHistory.setInt(2, input.getInt("taskId"));

			try (ResultSet rsHistory = psHistory.executeQuery()) {
				while (rsHistory.next()) {
					JSONObject task = new JSONObject();
					String dateTime = rsHistory.getString("DateTime");
					task.put("dateTime", (dateTime != null) ? Utilities.timeFormatter(dateTime) : null);
					task.put("taskStatus", rsHistory.getString("TaskStatus"));
					task.put("comments", rsHistory.getString("Comments"));
					taskHistory.put(task);
				}
			}
		} catch (SQLException | JSONException e) {
			LOGGER.error("Error retrieving task history: {}", e.getMessage());
			response.put("Error", "Failed to retrieve task history");
		}

		response.put("taskHistory", taskHistory);
		return response;
	}

	public JSONObject updateCurrentTaskStatus(JSONObject input) {
		JSONObject response = new JSONObject();
		String startDateTime = "";
		String endDateTime = Utilities.getCurrentDateTime();

		String query = "UPDATE task SET CurrentTaskStatus=? WHERE UserId=? AND Id=?";
		try {
			Connection conn = DatabaseManager.getConnection();
			PreparedStatement psUpdate = conn.prepareStatement(query);
			psUpdate.setString(1, input.getString("currentTaskStatus"));
			psUpdate.setInt(2, input.getInt("userId"));
			psUpdate.setInt(3, input.getInt("taskId"));
			psUpdate.executeUpdate();

			if (input.getString("currentTaskStatus").equalsIgnoreCase("Completed")) {
				query = "SELECT StartDateTime FROM task WHERE UserId=? AND Id=?";
				PreparedStatement psSelect = conn.prepareStatement(query);
				psSelect.setInt(1, input.getInt("userId"));
				psSelect.setInt(2, input.getInt("taskId"));
				ResultSet rs = psSelect.executeQuery();
				if (rs.next()) {
					startDateTime = rs.getString("StartDateTime");
				}

				query = "UPDATE task SET EndDateTime=?, TotalTimeSpent=? WHERE UserId=? AND Id=?";
				int totalTime = (int) Utilities.calculateDaysTaken(startDateTime, endDateTime);
				try (PreparedStatement psUpdateTotalTime = conn.prepareStatement(query)) {
					psUpdateTotalTime.setString(1, endDateTime);
					psUpdateTotalTime.setInt(2, totalTime);
					psUpdateTotalTime.setInt(3, input.getInt("userId"));
					psUpdateTotalTime.setInt(4, input.getInt("taskId"));
					psUpdateTotalTime.executeUpdate();
				}

				query = "INSERT INTO UserTaskHistory(UserId, TaskId, DateTime, TaskStatus, Comments) VALUES(?,?,?,?,?)";
				try (PreparedStatement psInsertHistory = conn.prepareStatement(query)) {
					psInsertHistory.setInt(1, input.getInt("userId"));
					psInsertHistory.setInt(2, input.getInt("taskId"));
					psInsertHistory.setString(3, Utilities.getCurrentDateTime());
					psInsertHistory.setString(4, "In Progress - Completed");
					psInsertHistory.setString(5, input.getString("comments"));
					psInsertHistory.executeUpdate();
				}

				response.put("Success Message", "Updated CurrentTaskStatus to Completed");
			}

			if (input.getString("currentTaskStatus").equalsIgnoreCase("In Progress")) {
				query = "UPDATE task SET EndDateTime=NULL, TotalTimeSpent=0 WHERE UserId=? AND Id=?";
				try (PreparedStatement psUpdateInProgress = conn.prepareStatement(query)) {
					psUpdateInProgress.setInt(1, input.getInt("userId"));
					psUpdateInProgress.setInt(2, input.getInt("taskId"));
					psUpdateInProgress.executeUpdate();
				}

				query = "SELECT usm.SprintId FROM UserSprintMapping usm LEFT OUTER JOIN UserSprintTaskMapping ustm ON (usm.Id=ustm.UserSprintMappingId) WHERE ustm.TaskId=?";
				try (PreparedStatement psSelectSprintId = conn.prepareStatement(query)) {
					psSelectSprintId.setInt(1, input.getInt("taskId"));
					try (ResultSet rs = psSelectSprintId.executeQuery()) {
						if (rs.next()) {
							int sprintId = rs.getInt("SprintId");
							String newquery = "UPDATE Sprint SET CurrentSprintStatus='Ongoing', ActualEndDate=NULL, ActualTimeTaken=NULL WHERE Id=?";
							try (PreparedStatement psUpdateSprint = conn.prepareStatement(newquery)) {
								psUpdateSprint.setInt(1, sprintId);
								psUpdateSprint.executeUpdate();
							}
						}
					}
				}

				query = "INSERT INTO UserTaskHistory(UserId, TaskId, DateTime, TaskStatus, Comments) VALUES(?,?,?,?,?)";
				try (PreparedStatement psInsertInProgress = conn.prepareStatement(query)) {
					psInsertInProgress.setInt(1, input.getInt("userId"));
					psInsertInProgress.setInt(2, input.getInt("taskId"));
					psInsertInProgress.setString(3, Utilities.getCurrentDateTime());
					psInsertInProgress.setString(4, "Completed - In Progress");
					psInsertInProgress.setString(5, "Auto: Task is moved from 'Completed' to 'In Progress'");
					psInsertInProgress.executeUpdate();
				}

				query = "INSERT INTO UserTaskHistory(UserId, TaskId, DateTime, TaskStatus, Comments) VALUES(?,?,?,?,?)";
				try (PreparedStatement psInsertReason = conn.prepareStatement(query)) {
					psInsertReason.setInt(1, input.getInt("userId"));
					psInsertReason.setInt(2, input.getInt("taskId"));
					psInsertReason.setString(3, Utilities.getCurrentDateTime());
					psInsertReason.setString(4, "In Progress");
					psInsertReason.setString(5, "Reason: " + input.getString("comments"));
					psInsertReason.executeUpdate();
				}

				response.put("Success Message", "Updated CurrentTaskStatus to In Progress");
			}
		} catch (SQLException | JSONException e) {
			LOGGER.error("Error updating current task status", e);
			response.put("Error", "Failed to update current task");
		}
		return response;
	}
}
