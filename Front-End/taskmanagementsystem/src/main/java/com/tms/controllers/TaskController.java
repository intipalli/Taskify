package com.tms.controllers;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;
import org.json.JSONTokener;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tms.java.ServiceResponse;
import com.tms.java.Utilities;

@Controller
public class TaskController {
	@RequestMapping(value = "/listTasks.htm", method = RequestMethod.GET)
	@ResponseBody
	public String listTasks(HttpServletRequest request) {
		try {
			Utilities utilities = new Utilities();

			String url = "/task";

			ServiceResponse serviceResponse = utilities.sendServiceRequest("", "GET", url, request);
			if (serviceResponse.getResponseCode() == 200) {
				return serviceResponse.getResponse().toString();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return "";
	}

	@RequestMapping(value = "/taskReport.htm", method = RequestMethod.GET)
	@ResponseBody
	public String searchTasks(@RequestParam("fromDate") String fromDate, @RequestParam("toDate") String toDate,
			HttpServletRequest request) {
		try {
			Utilities utilities = new Utilities();
			int userId = (int) request.getSession().getAttribute("userId");
			String url = "/taskReport";
			JSONObject data = new JSONObject();
			data.put("userId", userId);
			SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
			Date date1 = null;
			Date date2 = null;
			try {
				date1 = formatter.parse(fromDate.trim() + " " + "00:00:01.000");
				date2 = formatter.parse(toDate.trim() + " " + "23:59:59.000");
			} catch (ParseException e) {
				e.printStackTrace();
			}
			formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			data.put("fromDate", formatter.format(date1));
			data.put("toDate", formatter.format(date2));
			ServiceResponse serviceResponse = utilities.sendServiceRequest(data.toString(), "POST", url, request);
			if (serviceResponse.getResponseCode() == 200) {

				return serviceResponse.getResponse().toString();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return "";
	}

	@RequestMapping(value = "/updateCurrentTaskStatus.htm", method = RequestMethod.POST)
	@ResponseBody
	public String updateCurrentTaskStatus(@RequestParam("tid") int taskId, @RequestParam("status") String status,
			@RequestParam("comments") String comment, HttpServletRequest request) {
		try {
			Utilities utilities = new Utilities();
			int userId = (int) request.getSession().getAttribute("userId");
			String url = "/updateCurrentTaskStatus";
			JSONObject data = new JSONObject();

			data.put("userId", userId);
			data.put("taskId", taskId);
			data.put("currentTaskStatus", status);
			data.put("comments", comment);

			ServiceResponse serviceResponse = utilities.sendServiceRequest(data.toString(), "POST", url, request);
			if (serviceResponse.getResponseCode() == 200) {
				return serviceResponse.getResponse().toString();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return "";
	}

	@RequestMapping(value = "/updateTaskStatus.htm", method = RequestMethod.POST)
	@ResponseBody
	public String updateTaskStatus(@RequestParam("taskId") int taskId, @RequestParam("status") int status,
			HttpServletRequest request) {
		try {
			Utilities utilities = new Utilities();
			int userId = (int) request.getSession().getAttribute("userId");
			String url = "/taskStatus";
			JSONObject data = new JSONObject();

			data.put("userId", userId);
			data.put("taskId", taskId);
			data.put("Status", status);
			ServiceResponse serviceResponse = utilities.sendServiceRequest(data.toString(), "POST", url, request);
			if (serviceResponse.getResponseCode() == 200) {

				return serviceResponse.getResponse().toString();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return "";
	}

	@RequestMapping(value = "/editTask.htm", method = RequestMethod.POST)
	@ResponseBody
	public String editTask(@RequestParam("sprintId") int sprintId, @RequestParam("taskId") int taskId,
			@RequestParam("taskname") String taskName, @RequestParam("taskdescription") String taskDescription,
			@RequestParam("EstTime") int estTimeOfDelInMins, @RequestParam("Priority") String priority,
			HttpServletRequest request) {
		try {
			Utilities utilities = new Utilities();

			String url = "/task/" + taskId;
			JSONObject data = new JSONObject();
			data.put("sprintId", sprintId);

			data.put("id", taskId);
			data.put("taskName", taskName);
			data.put("taskDescription", taskDescription);
			data.put("estimatedTimeOfDelivery", estTimeOfDelInMins);
			data.put("priority", priority);

			ServiceResponse serviceResponse = utilities.sendServiceRequest(data.toString(), "POST", url, request);
			if (serviceResponse.getResponseCode() == 200) {

				return serviceResponse.getResponse().toString();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return "";
	}

	@RequestMapping(value = "/addSprintTask.htm", method = RequestMethod.POST)
	@ResponseBody
	public String addSprintTask(@RequestParam("sprintId") String id, @RequestParam("taskName") String taskName,
			@RequestParam("taskDescription") String taskDescription, @RequestParam("estTime") int estTimeOfDelInMins,
			@RequestParam("priority") String priority, HttpServletRequest request) {
		try {
			Utilities utilities = new Utilities();
			String url = "/addSprintTask";
			JSONObject data = new JSONObject();
			data.put("userId", request.getSession().getAttribute("userId"));
			data.put("sprintId", id);
			data.put("taskName", taskName);
			data.put("taskDescription", taskDescription);
			data.put("estimatedTimeOfDelivery", estTimeOfDelInMins);
			data.put("priority", priority);

			ServiceResponse serviceResponse = utilities.sendServiceRequest(data.toString(), "POST", url, request);
			if (serviceResponse.getResponseCode() == 200) {

				return serviceResponse.getResponse().toString();
			} else {
				return serviceResponse.getResponse().toString();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return "";
	}

	@RequestMapping(value = "/listSprintTasks.htm", method = RequestMethod.GET)
	@ResponseBody
	public String listSprintTasks(@RequestParam("sprintId") int id, HttpServletRequest request) {
		try {
			Utilities utilities = new Utilities();
			int userId = (int) request.getSession().getAttribute("userId");
			String url = "/listSprintTask";
			JSONObject data = new JSONObject();
			data.put("userId", userId);
			data.put("sprintId", id);

			ServiceResponse serviceResponse = utilities.sendServiceRequest(data.toString(), "POST", url, request);
			if (serviceResponse.getResponseCode() == 200) {
				return serviceResponse.getResponse().toString();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return "";
	}

	@RequestMapping(value = "/taskTransaction", method = RequestMethod.POST)
	@ResponseBody
	public String taskTransaction(@RequestParam("taskId") int tid, HttpServletRequest request) {
		try {
			Utilities utilities = new Utilities();
			String url = "/userTaskStatusCheck";
			JSONObject data = new JSONObject();
			data.put("taskId", tid);
			data.put("userId", request.getSession().getAttribute("userId"));
			ServiceResponse serviceResponse = utilities.sendServiceRequest(data.toString(), "POST", url, request);
			if (serviceResponse.getResponseCode() == 200) {
				JSONTokener tokener = new JSONTokener(serviceResponse.getResponse());
				JSONObject jsonValue = new JSONObject(tokener);

				return jsonValue.toString();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return "";
	}

}
