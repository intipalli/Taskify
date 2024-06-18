package com.tms.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SprintService {

	private static final Logger logger = LoggerFactory.getLogger(SprintService.class);

	public JSONObject addSprint(JSONObject input) throws Exception {
		JSONObject response = new JSONObject();
		String insertQuery = "INSERT INTO sprint (Name, Objective, StartDate, EndDate, Duration, CurrentSprintStatus, Status) VALUES (?, ?, ?, ?, ?, ?, 1)";
		String selectQuery = "SELECT Id FROM Sprint WHERE Name = ?";
		Connection conn = null;
		PreparedStatement insertStmt = null;
		PreparedStatement selectStmt = null;
		ResultSet rs = null;

		try {
			conn = DatabaseManager.getConnection();
			insertStmt = conn.prepareStatement(insertQuery);
			selectStmt = conn.prepareStatement(selectQuery);

			int duration = Utilities.totalTimeSpentDays(input.getString("startDate"), input.getString("endDate"));

			// Insert sprint details into the database
			insertStmt.setString(1, input.getString("sprintName"));
			insertStmt.setString(2, input.getString("objective"));
			insertStmt.setString(3, input.getString("startDate"));
			insertStmt.setString(4, input.getString("endDate"));
			insertStmt.setInt(5, duration);
			if (Utilities.currentDateIsAfter(input.getString("startDate")))
				insertStmt.setString(6, "Ongoing");
			else
				insertStmt.setString(6, "Upcoming");

			insertStmt.executeUpdate();

			// Retrieve the ID of the newly inserted sprint
			selectStmt.setString(1, input.getString("sprintName"));
			rs = selectStmt.executeQuery();
			if (rs.next()) {
				response.put("sprintName", input.getString("sprintName"));
				response.put("sprintId", rs.getInt("Id"));
			}
		} catch (SQLException | JSONException e) {
			e.printStackTrace();
			String errorMsg = "Error adding sprint: " + e.getMessage();
			throw new Exception(errorMsg, e);
		}
		return response;
	}

	public JSONObject updateSprint(JSONObject input, int sprintId) {
		JSONObject response = new JSONObject();
		String updateQuery = "UPDATE sprint SET Name = ?, Objective = ?, StartDate = ?, EndDate = ?, Duration = ? WHERE Id = ?";
		String selectQuery = "SELECT Name FROM Sprint WHERE Id = ?";

		try (Connection conn = DatabaseManager.getConnection();
				PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
				PreparedStatement selectStmt = conn.prepareStatement(selectQuery)) {

			int duration = Utilities.totalTimeSpentDays(input.getString("startDate"), input.getString("endDate"));

			// Update sprint details in the database
			updateStmt.setString(1, input.getString("sprintName"));
			updateStmt.setString(2, input.getString("objective"));
			updateStmt.setString(3, input.getString("startDate"));
			updateStmt.setString(4, input.getString("endDate"));
			updateStmt.setInt(5, duration);
			updateStmt.setInt(6, sprintId);
			updateStmt.executeUpdate();

			// Retrieve the updated sprint name
			selectStmt.setInt(1, sprintId);
			try (ResultSet rs = selectStmt.executeQuery()) {
				if (rs.next()) {
					response.put("sprintName", rs.getString("Name"));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return response;
	}

	public JSONObject fetchSprint(JSONObject input) throws Exception {
		JSONObject response = new JSONObject();
		JSONArray array = new JSONArray();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		// SimpleDateFormat to convert mm/dd/yyyy to yyyy-mm-dd
		SimpleDateFormat inputFormat = new SimpleDateFormat("MM/dd/yyyy");
		SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");

		try {
			conn = DatabaseManager.getConnection();

			String startDate = input.getString("startDate");
			String endDate = input.getString("endDate");
			String query;

			// Check if startDate or endDate is empty
			if (startDate.isEmpty() && endDate.isEmpty()) {
				query = "SELECT * FROM sprint";
				pstmt = conn.prepareStatement(query);
			} else {
				query = "SELECT * FROM sprint WHERE STR_TO_DATE(StartDate, '%m/%d/%Y') >= STR_TO_DATE(?, '%Y-%m-%d') AND STR_TO_DATE(EndDate, '%m/%d/%Y') <= STR_TO_DATE(?, '%Y-%m-%d')";
				pstmt = conn.prepareStatement(query);

				// Convert startDate and endDate to yyyy-MM-dd format
				String formattedStartDate = outputFormat.format(inputFormat.parse(startDate));
				String formattedEndDate = outputFormat.format(inputFormat.parse(endDate));

				pstmt.setString(1, formattedStartDate);
				pstmt.setString(2, formattedEndDate);
			}

			rs = pstmt.executeQuery();
			while (rs.next()) {
				JSONObject result = new JSONObject();
				result.put("sprintId", rs.getInt("Id"));
				result.put("sprintName", rs.getString("Name"));
				result.put("objective", rs.getString("Objective"));
				result.put("startDate", rs.getString("StartDate"));
				result.put("endDate", rs.getString("EndDate"));
				result.put("duration", rs.getInt("Duration"));
				result.put("actualEndDate",
						rs.getString("ActualEndDate") != null ? rs.getString("ActualEndDate") : null);
				result.put("actualTimeTaken", rs.getString("ActualTimeTaken"));
				result.put("currentSprintStatus", rs.getString("CurrentSprintStatus"));
				if (!rs.getString("CurrentSprintStatus").equalsIgnoreCase("completed")) {
					boolean flag1 = Utilities.currentDateIsAfter(rs.getString("EndDate"));
					if (flag1) {
						result.put("sprintCompleted", "true");
					} else
						result.put("sprintCompleted", "false");
					boolean flag2 = Utilities.currentDateIsAfter(rs.getString("StartDate"));
					if (flag2) {
						pstmt = conn.prepareStatement("update sprint set currentSprintStatus = 'Ongoing' where Id = ?");
						pstmt.setInt(1, rs.getInt("Id"));
						int r = pstmt.executeUpdate();
						if (r > 0)
							result.put("changeToOngoing", "true");
					} else {
						pstmt = conn
								.prepareStatement("update sprint set currentSprintStatus = 'Upcoming' where Id = ?");
						pstmt.setInt(1, rs.getInt("Id"));
						int r = pstmt.executeUpdate();
						if (r > 0)
							result.put("changeToUpcoming", "true");
					}
				}
				array.put(result);
			}

			response.put("sprints", array);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return response;
	}

	public JSONObject updateSprintStatus(int sprintId) throws Exception {
		JSONObject response = new JSONObject();
		ArrayList<Integer> usmIdList = new ArrayList<>();
		ArrayList<Integer> taskIdList = new ArrayList<>();
		boolean allTasksCompleted = true;

		try (Connection conn = DatabaseManager.getConnection()) {
			PreparedStatement pstmt;
			ResultSet rs;

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

			// Check if all tasks are completed
			for (int taskId : taskIdList) {
				query = "SELECT CurrentTaskStatus FROM task WHERE Id=?";
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, taskId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					String currentTaskStatus = rs.getString("CurrentTaskStatus");
					if (!currentTaskStatus.equalsIgnoreCase("Completed")) {
						allTasksCompleted = false;
						break;
					}
				}
			}

			// Update sprint status based on task completion
			if (allTasksCompleted) {
				String startDate = "";
				response.put("Success", "All tasks in the sprint are completed");

				// Retrieve start date of the sprint
				query = "SELECT StartDate FROM Sprint WHERE Id=?";
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, sprintId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					startDate = rs.getString("StartDate");
				}

				// Update sprint status to Completed
				query = "UPDATE Sprint SET CurrentSprintStatus='Completed', ActualEndDate=?, ActualTimeTaken=? WHERE Id=?";
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, Utilities.getCurrentDate());
				pstmt.setInt(2, Utilities.totalTimeSpentDays(startDate, Utilities.getCurrentDate()));
				pstmt.setInt(3, sprintId);
				pstmt.executeUpdate();
			} else {
				response.put("Warning", "All tasks in this sprint are not yet completed");
			}

		} catch (Exception e) {
			String errorMsg = "Error updating sprint status: " + e.getMessage();
			logger.error(errorMsg, e);
		}

		return response;
	}
}
