package com.tms.controllers;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tms.java.ServiceResponse;
import com.tms.java.Utilities;

@Controller
public class SprintController {
	@RequestMapping(value = "/addSprint.htm", method = RequestMethod.POST)
	@ResponseBody
	public String addSprint(@RequestParam("sprintName") String sprintName,
			@RequestParam("sprintObjective") String sprintObjective, @RequestParam("sprintRange") String range,
			HttpServletRequest request) {
		try {
			Utilities utilities = new Utilities();
			String url = "/sprint";
			String fromDate = range.split("-")[0].trim();
			String toDate = range.split("-")[1].trim();
			JSONObject data = new JSONObject();

			data.put("sprintName", sprintName);
			data.put("objective", sprintObjective);

			data.put("startDate", fromDate);
			data.put("endDate", toDate);

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

	@RequestMapping(value = "/editSprint.htm", method = RequestMethod.POST)
	@ResponseBody
	public String editSprint(@RequestParam("sprintId") String id, @RequestParam("sprintname") String name,
			@RequestParam("sprintobjective") String objective, @RequestParam("sprintrange") String range,
			HttpServletRequest request) {
		try {
			Utilities utilities = new Utilities();
			String url = "/sprint/" + id;
			String fromDate = range.split("-")[0].trim();
			String toDate = range.split("-")[1].trim();
			JSONObject data = new JSONObject();

			data.put("sprintName", name);
			data.put("objective", objective);

			data.put("startDate", fromDate);
			data.put("endDate", toDate);

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

	@RequestMapping(value = "/updateSprintStatus.htm", method = RequestMethod.POST)
	@ResponseBody
	public String updateSprintStatus(@RequestParam("id") int id, HttpServletRequest request) {
		try {
			Utilities utilities = new Utilities();

			String url = "/updateSprintStatus/" + id;

			ServiceResponse serviceResponse = utilities.sendServiceRequest("", "GET", url, request);
			if (serviceResponse.getResponseCode() == 200) {

				return serviceResponse.getResponse().toString();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return "";
	}

	@RequestMapping(value = "/fetchSprint.htm", method = RequestMethod.GET)
	@ResponseBody
	public String fetchSprints(@RequestParam("fromDate") String fromDate, @RequestParam("toDate") String toDate,
			HttpServletRequest request) {
		try {
			Utilities utilities = new Utilities();

			String url = "/fetchSprint";
			JSONObject data = new JSONObject();

			data.put("startDate", fromDate);
			data.put("endDate", toDate);

			ServiceResponse serviceResponse = utilities.sendServiceRequest(data.toString(), "POST", url, request);
			if (serviceResponse.getResponseCode() == 200) {
				return serviceResponse.getResponse().toString();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return "";
	}

}
