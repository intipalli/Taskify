package com.tms.controllers;

import java.text.SimpleDateFormat;
import java.util.Date;

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
public class CommentsController {

    @RequestMapping(value = "/taskHistory.htm", method = RequestMethod.GET)
    @ResponseBody
    public String taskHistory(@RequestParam("taskId") int taskId, HttpServletRequest request) {
        try {
            Utilities utilities = new Utilities();
            int userId = (int) request.getSession().getAttribute("userId");
            String url = "/taskHistory";
            JSONObject data = new JSONObject();

            data.put("userId", userId);
            data.put("taskId", taskId);
            ServiceResponse serviceResponse = utilities.sendServiceRequest(data.toString(), "POST", url, request);
            if (serviceResponse.getResponseCode() == 200) {

                return serviceResponse.getResponse().toString();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return "";
    }

    @RequestMapping(value = "/addComment.htm", method = RequestMethod.POST)
    @ResponseBody
    public String addComment(@RequestParam("taskId") int taskId,
            @RequestParam(value = "comments", required = false) String comments, HttpServletRequest request) {
        try {
            Utilities utilities = new Utilities();
            int userId = (int) request.getSession().getAttribute("userId");
            String url = "/addComment";
            JSONObject data = new JSONObject();

            data.put("userId", userId);
            data.put("taskId", taskId);
            data.put("comments", "Manual: " + comments);
            ServiceResponse serviceResponse = utilities.sendServiceRequest(data.toString(), "POST", url, request);
            if (serviceResponse.getResponseCode() == 200) {

                return serviceResponse.getResponse().toString();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return "";
    }

    @RequestMapping(value = "/editComment.htm", method = RequestMethod.POST)
    @ResponseBody
    public String editComment(@RequestParam("taskId") int taskId, @RequestParam(value = "Comment") String comments,
            @RequestParam("dateTime") String datetime, @RequestParam("status") String status,
            HttpServletRequest request) {
        try {
            Utilities utilities = new Utilities();
            int userId = (int) request.getSession().getAttribute("userId");
            String url = "/editComment";
            JSONObject data = new JSONObject();

            data.put("userId", userId);
            data.put("taskId", taskId);
            data.put("comments", comments);
            data.put("Status", status);

            SimpleDateFormat inputFormatter = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
            SimpleDateFormat outputFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            Date date = inputFormatter.parse(datetime);

            data.put("dateTime", outputFormatter.format(date));
            System.out.println(data);

            ServiceResponse serviceResponse = utilities.sendServiceRequest(data.toString(), "POST", url, request);
            if (serviceResponse.getResponseCode() == 200) {

                return serviceResponse.getResponse().toString();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return "";
    }

    @RequestMapping(value = "/deleteComment.htm", method = RequestMethod.POST)
    @ResponseBody
    public String deleteComment(@RequestParam("taskId") int taskId, @RequestParam("dateTime") String datetime,
            @RequestParam("status") String status,
            HttpServletRequest request) {
        try {
            Utilities utilities = new Utilities();
            int userId = (int) request.getSession().getAttribute("userId");
            String url = "/deleteComment";
            JSONObject data = new JSONObject();

            data.put("userId", userId);
            data.put("taskId", taskId);
            SimpleDateFormat inputFormatter = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
            SimpleDateFormat outputFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            Date date = inputFormatter.parse(datetime);

            data.put("dateTime", outputFormatter.format(date));
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

}
