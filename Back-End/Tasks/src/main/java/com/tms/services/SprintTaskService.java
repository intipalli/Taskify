package com.tms.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class SprintTaskService {

	public JSONObject addSprintTask(JSONObject input) throws JSONException {
		JSONObject response = new JSONObject();
		int taskId = 0, userSprintMappingId = 0;
		String createdDateTime = Utilities.getCurrentDateTime();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			Connection conn = DatabaseManager.getConnection();
			// Check if the task already exists in the sprint
			String query = "SELECT t.Id FROM sprint s "
					+ "LEFT OUTER JOIN UserSprintMapping usm ON (usm.SprintId = s.Id) "
					+ "LEFT OUTER JOIN UserSprintTaskMapping ustm ON (ustm.UserSprintMappingId = usm.Id) "
					+ "LEFT OUTER JOIN task t ON (ustm.TaskId = t.Id) " + "WHERE t.TaskName = ? AND s.Id = ?";

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, input.getString("taskName"));
			pstmt.setInt(2, input.getInt("sprintId"));

			rs = pstmt.executeQuery();

			if (!rs.next()) {

				// Insert new task
				query = "INSERT INTO task(UserId, TaskName, TaskDescription, EstimatedTimeOfDelivery, Priority, CurrentTaskStatus, StartDateTime, Status) "
						+ "VALUES (?, ?, ?, ?, ?, 'In Progress', ?, 1)";

				pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
				pstmt.setInt(1, input.getInt("userId"));
				pstmt.setString(2, input.getString("taskName"));
				pstmt.setString(3, input.getString("taskDescription"));
				pstmt.setInt(4, input.getInt("estimatedTimeOfDelivery"));
				pstmt.setString(5, input.getString("priority"));
				pstmt.setString(6, createdDateTime);

				pstmt.executeUpdate();

				// Retrieve the newly inserted task's ID
				rs = pstmt.getGeneratedKeys();
				if (rs.next()) {
					taskId = rs.getInt(1);
				}

				// Insert into UserSprintMapping
				query = "INSERT INTO UserSprintMapping(UserId, SprintId) VALUES (?, ?)";
				pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
				pstmt.setInt(1, input.getInt("userId"));
				pstmt.setInt(2, input.getInt("sprintId"));

				pstmt.executeUpdate();

				// Retrieve the UserSprintMapping ID
				rs = pstmt.getGeneratedKeys();
				if (rs.next()) {
					userSprintMappingId = rs.getInt(1);
				}

				// Insert into UserSprintTaskMapping
				query = "INSERT INTO UserSprintTaskMapping(UserSprintMappingId, TaskId) VALUES (?, ?)";
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, userSprintMappingId);
				pstmt.setInt(2, taskId);

				pstmt.executeUpdate();

				response.put("sprintId", input.getInt("sprintId"));
				response.put("taskId", taskId);
				response.put("taskName", input.getString("taskName"));

				// Insert into UserTaskHistory
				query = "INSERT INTO UserTaskHistory(UserId, TaskId, `DateTime`, TaskStatus, Comments) VALUES (?, ?, ?, ?, ?)";
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, input.getInt("userId"));
				pstmt.setInt(2, taskId);
				pstmt.setString(3, Utilities.getCurrentDateTime());
				pstmt.setString(4, "In Progress");
				pstmt.setString(5, "Auto: Task is started");

				pstmt.executeUpdate();

				response.put("Success", "Task added successfully to sprint.");

			} else {
				// Task with the same name already exists in the sprint
				response.put("Warning", "A task with this name already exists in the sprint.");
			}

		} catch (SQLException e) {
			e.printStackTrace();
			response.put("Error", e.getMessage());
		}
		return response;
	}

	public JSONObject listSprintTask(JSONObject input) throws JSONException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONObject response = new JSONObject();
		JSONArray array = new JSONArray();
		ArrayList<Integer> usmId = new ArrayList<>();
		ArrayList<Integer> taskId = new ArrayList<>();

		try {
			Connection conn = DatabaseManager.getConnection();
			// Fetch UserSprintMapping IDs for the given sprint
			String query = "SELECT Id FROM UserSprintMapping WHERE SprintId=?";
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, input.getInt("sprintId"));
			rs = pstmt.executeQuery();
			while (rs.next()) {
				usmId.add(rs.getInt("Id"));
			}

			// Fetch Sprint details
			query = "SELECT Id, Name, Objective, StartDate, EndDate, Duration, CurrentSprintStatus, ActualEndDate, ActualTimeTaken "
					+ "FROM Sprint WHERE Id=?";
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, input.getInt("sprintId"));
			rs = pstmt.executeQuery();
			if (rs.next()) {
				response.put("userId", input.getInt("userId"));
				response.put("sprintId", rs.getInt("Id"));
				response.put("sprintName", rs.getString("Name"));
				response.put("objective", rs.getString("Objective"));
				response.put("startDate", rs.getString("StartDate"));
				response.put("endDate", rs.getString("EndDate"));
				response.put("duration", rs.getInt("Duration"));
				response.put("actualEndDate", rs.getString("ActualEndDate") != null ? rs.getString("ActualEndDate")
						: rs.getString("ActualEndDate"));
				response.put("actualTimeTaken", rs.getString("ActualTimeTaken"));
				response.put("currentSprintStatus", rs.getString("CurrentSprintStatus"));
			}

			// Fetch distinct task IDs associated with UserSprintMapping IDs
			query = "SELECT DISTINCT taskId FROM UserSprintTaskMapping WHERE UserSprintMappingId=?";
			for (int usmIdVal : usmId) {
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, usmIdVal);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					taskId.add(rs.getInt("taskId"));
				}
			}

			// Fetch task details for each taskId
			for (int taskIdVal : taskId) {
				query = "SELECT t.UserId, t.TaskName, t.TaskDescription, t.StartDateTime, t.EndDateTime, "
						+ "t.EstimatedTimeOfDelivery, t.TotalTimeSpent, t.Priority, t.Status, t.CurrentTaskStatus, "
						+ "tmsu.FirstName, tmsu.LastName "
						+ "FROM task t LEFT OUTER JOIN tmsusers tmsu ON (tmsu.Id = t.UserId) " + "WHERE t.Id=?";
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, taskIdVal);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					JSONObject task = new JSONObject();
					task.put("userId", rs.getString("UserId"));
					task.put("userName", rs.getString("FirstName") + " " + rs.getString("LastName"));
					task.put("taskId", taskIdVal);
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
					array.put(task);
				}
			}

			response.put("tasks", array);

		} catch (SQLException e) {
			e.printStackTrace();
			response.put("Error", e.getMessage());
		}

		return response;
	}
}
