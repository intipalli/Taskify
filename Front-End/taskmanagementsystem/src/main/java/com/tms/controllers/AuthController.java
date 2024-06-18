package com.tms.controllers;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;
import org.json.JSONTokener;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tms.java.ServiceResponse;
import com.tms.java.Utilities;

@Controller
public class AuthController {

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public ModelAndView doLogin(@RequestParam("userName") String username, @RequestParam("Passwd") String password,
            ModelAndView mav, HttpServletRequest request) {

        Utilities utilities = new Utilities();
        ServiceResponse serviceResponse = null;

        try {

            JSONObject data = new JSONObject();
            data.put("userName", username);
            data.put("password", password);
            serviceResponse = utilities.sendServiceRequest(data.toString(), "POST", "/login", request);
            if (serviceResponse.getResponseCode() == 200) {
                JSONTokener tokener = new JSONTokener(serviceResponse.getResponse());
                JSONObject jsonValue = new JSONObject(tokener);
                if (jsonValue.has("Error")) {

                    mav.setViewName("login");
                    mav.addObject("ErrorMessage", jsonValue.getString("Error"));
                    return mav;
                } else {
                    request.getSession().setAttribute("TOKEN", jsonValue.getString("token"));
                    request.getSession().setAttribute("Role", jsonValue.getString("role"));

                    request.getSession().setAttribute("userId", jsonValue.getInt("id"));
                    request.getSession().setAttribute("fullName",
                            jsonValue.getString("firstName") + " " + jsonValue.getString("lastName"));
                    request.getSession().setAttribute("firstName", jsonValue.getString("firstName"));
                    request.getSession().setAttribute("lastName", jsonValue.getString("lastName"));
                    request.getSession().setAttribute("Email", jsonValue.getString("email"));
                    request.getSession().setAttribute("Username", jsonValue.getString("username"));
                    request.getSession().setAttribute("phone", jsonValue.getString("mobile"));

                    mav.addObject("fullName", jsonValue.get("firstName") + " " + jsonValue.getString("lastName"));
                    mav = new ModelAndView("redirect:/home");

                    return mav;
                }
            } else {
                mav.setViewName("error");
                mav.addObject("Error", serviceResponse.getResponseCode());
                return mav;
            }
        } catch (Exception e) {

            e.printStackTrace();
        }
        return mav;
    }

    @RequestMapping(value = "/generateOtp.htm", method = RequestMethod.POST)
    @ResponseBody
    public String generateOtp(@RequestParam("userName") String userName, HttpServletRequest request) {
        try {
            Utilities utilities = new Utilities();

            String url = "/generateOtp";
            JSONObject data = new JSONObject();
            data.put("userName", userName);

            ServiceResponse serviceResponse = utilities.sendServiceRequest(data.toString(), "POST", url, request);
            if (serviceResponse.getResponseCode() == 200) {
                return serviceResponse.getResponse().toString();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return "";
    }

    @RequestMapping(value = "/verifyOtp.htm", method = RequestMethod.POST)
    @ResponseBody
    public String verifyOtp(@RequestParam("userName") String userName, @RequestParam("otp") String otp,
            HttpServletRequest request) {
        try {
            Utilities utilities = new Utilities();

            String url = "/verifyOtp";
            JSONObject data = new JSONObject();
            data.put("userName", userName);
            data.put("otp", otp);

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