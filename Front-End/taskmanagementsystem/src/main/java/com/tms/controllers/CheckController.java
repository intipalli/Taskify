package com.tms.controllers;

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
public class CheckController {
    @RequestMapping(value = "/checkUsername", method = RequestMethod.GET)
    @ResponseBody
    public String checkUsername(@RequestParam("userName") String username, HttpServletRequest request) {
        try {
            Utilities utilities = new Utilities();
            String url = "/isUserAvailable";

            JSONObject data = new JSONObject();

            data.put("userName", username);
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

    @RequestMapping(value = "/isEmailExists", method = RequestMethod.GET)
    @ResponseBody
    public String checkEmail(@RequestParam("emailId") String email, HttpServletRequest request) {
        try {
            Utilities utilities = new Utilities();
            String url = "/isEmailValid";

            JSONObject data = new JSONObject();

            data.put("email", email);
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

    @RequestMapping(value = "/isSprintNameAvailable.htm", method = RequestMethod.POST)
    @ResponseBody
    public String addSprint(@RequestParam("sprintName") String sprintName, HttpServletRequest request) {
        try {
            Utilities utilities = new Utilities();
            String url = "/isSprintAvailable";
            JSONObject data = new JSONObject();
            data.put("sprintName", sprintName);

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

    @RequestMapping(value = "/isTaskNameAvailable.htm", method = RequestMethod.POST)
    @ResponseBody
    public String isTaskNamePresent(@RequestParam("taskName") String taskName, @RequestParam("sprintId") String sid,
            HttpServletRequest request) {
        try {
            Utilities utilities = new Utilities();
            String url = "/isTaskAvailable";
            JSONObject data = new JSONObject();
            data.put("taskName", taskName);
            data.put("sprintId", sid);

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

    @RequestMapping(value = "/isSprintEmpty.htm", method = RequestMethod.POST)
    @ResponseBody
    public String isSprintEmpty(@RequestParam("sprintId") String id, HttpServletRequest request) {
        try {
            Utilities utilities = new Utilities();
            String url = "/sprintCheck/" + id;

            ServiceResponse serviceResponse = utilities.sendServiceRequest("", "GET", url, request);
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

    @RequestMapping(value = "/userActive", method = RequestMethod.GET)
    @ResponseBody
    public String userActive(@RequestParam("userName") String username, HttpServletRequest request) {
        try {
            Utilities utilities = new Utilities();
            String url = "/isUserActive/" + username;
            ServiceResponse serviceResponse = utilities.sendServiceRequest("", "GET", url, request);
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