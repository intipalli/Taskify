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
public class SettingsController {

    @RequestMapping(value = "/resetPassword.htm", method = RequestMethod.POST)
    @ResponseBody
    public String resetPassword(@RequestParam("userName") String userName, @RequestParam("Password") String newPassword,
            HttpServletRequest request) {
        try {
            Utilities utilities = new Utilities();

            String url = "/forgotPassword";
            JSONObject data = new JSONObject();
            data.put("userName", userName);
            data.put("newPassword", newPassword);

            ServiceResponse serviceResponse = utilities.sendServiceRequest(data.toString(), "POST", url, request);
            if (serviceResponse.getResponseCode() == 200) {

                return serviceResponse.getResponse().toString();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return "";
    }

    @RequestMapping(value = "/editProfile.htm", method = RequestMethod.POST)
    @ResponseBody
    public String editProfile(@RequestParam("userId") int userid, @RequestParam("firstName") String firstName,
            @RequestParam("lastName") String lastName,
            @RequestParam("emailId") String email, @RequestParam("phoneNumber") String phone,
            HttpServletRequest request) {
        try {
            Utilities utilities = new Utilities();

            String url = "/editProfile";
            JSONObject data = new JSONObject();
            data.put("userId", userid);
            data.put("firstName", firstName);
            data.put("lastName", lastName);
            data.put("email", email);
            data.put("phone", phone);
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
