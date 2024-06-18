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
public class UserController {
	@RequestMapping(value = "/addUser.htm", method = RequestMethod.POST)
	@ResponseBody
	public String addUser(@RequestParam("userName") String username, @RequestParam("firstName") String firstName,
			@RequestParam("lastName") String lastName, @RequestParam("Email") String email,
			@RequestParam("Mobile") String mobile, @RequestParam("Password") String password,
			HttpServletRequest request) {
		try {
			Utilities utilities = new Utilities();
			String url = "/user";

			JSONObject data = new JSONObject();

			data.put("userName", username);
			data.put("firstName", firstName);
			data.put("lastName", lastName);
			data.put("email", email);
			data.put("mobile", mobile);
			data.put("password", password);
			ServiceResponse serviceResponse = utilities.sendServiceRequest(data.toString(), "POST", url, request);
			if (serviceResponse.getResponseCode() == 200) {

				return serviceResponse.getResponse().toString();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return "";
	}

	@RequestMapping(value = "/listUsers.htm", method = RequestMethod.GET)
	@ResponseBody
	public String listUsers(HttpServletRequest request) {
		try {
			Utilities utilities = new Utilities();

			String url = "/listUser";

			ServiceResponse serviceResponse = utilities.sendServiceRequest("", "GET", url, request);
			if (serviceResponse.getResponseCode() == 200) {
				return serviceResponse.getResponse().toString();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return "";
	}

	@RequestMapping(value = "/updateUserStatus.htm", method = RequestMethod.POST)
	@ResponseBody
	public String updateUserStatus(@RequestParam("userId") int userId, @RequestParam("status") int status,
			HttpServletRequest request) {
		try {
			Utilities utilities = new Utilities();
			String url = "/activateInactivateUser";
			JSONObject data = new JSONObject();

			data.put("id", userId);
			data.put("status", status);
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
