package com.tms.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ReportsService {

	private static final Logger logger = LoggerFactory.getLogger(ReportsService.class);

	// Function to retrieve task report.
	public JSONObject getTaskReport(JSONObject input) throws JSONException, SQLException {
		JSONObject response = new JSONObject();
		JSONArray tasks = new JSONArray();

		String query = "SELECT DISTINCT t.*, s.Id AS sprintId, s.Name AS sprintName " + "FROM task t "
				+ "LEFT OUTER JOIN UserSprintTaskMapping ustm ON (ustm.TaskId = t.Id) "
				+ "LEFT OUTER JOIN UserSprintMapping usm ON (usm.Id = ustm.UserSprintMappingId) "
				+ "LEFT OUTER JOIN sprint s ON (s.Id = usm.SprintId) "
				+ "WHERE t.StartDateTime >= ? AND t.StartDateTime <= ? AND t.UserId = ?";

		try (Connection conn = DatabaseManager.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

			ps.setString(1, input.getString("fromDate"));
			ps.setString(2, input.getString("toDate"));
			ps.setInt(3, input.getInt("userId"));

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					JSONObject task = new JSONObject();
					task.put("id", rs.getInt("Id"));
					task.put("sprintId", rs.getInt("sprintId"));
					task.put("sprintName", rs.getString("sprintName"));
					task.put("taskName", rs.getString("TaskName"));
					task.put("taskDescription", rs.getString("TaskDescription"));
					task.put("startDateTime", Utilities.timeFormatter(rs.getString("StartDateTime")));
					task.put("endDateTime",
							rs.getString("EndDateTime") != null ? Utilities.timeFormatter(rs.getString("EndDateTime"))
									: rs.getString("EndDateTime"));
					task.put("estimatedTimeOfDelivery", rs.getString("EstimatedTimeOfDelivery"));
					task.put("totalTimeSpent", rs.getInt("TotalTimeSpent"));
					task.put("priority", rs.getString("Priority"));
					task.put("status", rs.getInt("Status"));
					task.put("currentTaskStatus", rs.getString("CurrentTaskStatus"));
					tasks.put(task);
				}
			}
		} catch (SQLException e) {
			logger.error("Error executing SQL query: {}", e.getMessage());
			throw new SQLException("Error retrieving task report", e);
		}

		response.put("tasks", tasks);
		return response;
	}
}
