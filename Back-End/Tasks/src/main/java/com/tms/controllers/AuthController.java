package com.tms.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.tms.services.AuthService;
import com.tms.services.CheckService;
import com.tms.services.UserService;

@RestController
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    private AuthService authService = new AuthService();
    private UserService userService = new UserService();
    private CheckService checkService = new CheckService();

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> login(@RequestBody String jsonInput,
                                                      HttpServletRequest httpRequest, HttpServletResponse httpResponse) {
        JSONObject jsonInputObj = new JSONObject(jsonInput);
        JSONObject jsonResponse = new JSONObject();

        try {
            if (!checkService.checkUsername(jsonInputObj.getString("userName"))) {
                jsonResponse.put("Error", "User does not exist");
                return new ResponseEntity<>(jsonResponse.toString(), HttpStatus.OK);
            } else if (!checkService.checkPassword(jsonInputObj)) {
                jsonResponse.put("Error", "Incorrect password");
                return new ResponseEntity<>(jsonResponse.toString(), HttpStatus.OK);
            } else {
                if ("Inactive".equalsIgnoreCase(userService.getUserStatus(jsonInputObj.getString("userName")).getString("Status"))) {
                    jsonResponse.put("Error", "User is inactivated. Please contact admin.");
                    return new ResponseEntity<>(jsonResponse.toString(), HttpStatus.OK);
                }
                jsonResponse = authService.login(jsonInputObj);
            }
        } catch (Exception e) {
            logger.error("Exception occurred during login", e);
            e.printStackTrace();
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }

        return new ResponseEntity<>(jsonResponse.toString(), HttpStatus.OK);
    }

    @RequestMapping(value = "/forgotPassword", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> forgotPassword(@RequestBody String jsonInput,
                                                               HttpServletRequest httpRequest, HttpServletResponse httpResponse) {
        JSONObject jsonInputObj = new JSONObject(jsonInput);
        JSONObject jsonResponse = new JSONObject();

        try {
            if (!checkService.checkUsername(jsonInputObj.getString("userName"))) {
                jsonResponse.put("Error", "User does not exist");
                return new ResponseEntity<>(jsonResponse.toString(), HttpStatus.OK);
            }
            jsonResponse = authService.forgotPassword(jsonInputObj);
        } catch (Exception e) {
            logger.error("Exception occurred during forgotPassword", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }

        return new ResponseEntity<>(jsonResponse.toString(), HttpStatus.OK);
    }

    @RequestMapping(value = "/generateOtp", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> generateOtp(@RequestBody String jsonInput,
                                                            HttpServletRequest httpRequest, HttpServletResponse httpResponse) {
        JSONObject jsonInputObj = new JSONObject(jsonInput);
        JSONObject jsonResponse = new JSONObject();
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Type", "application/json;charset=utf-8");

        try {
            jsonResponse = authService.generateOtp(jsonInputObj);
        } catch (Exception e) {
            logger.error("Exception occurred during generateOtp", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }

        return new ResponseEntity<>(jsonResponse.toString(), headers, HttpStatus.OK);
    }

    @RequestMapping(value = "/verifyOtp", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> verifyOtp(@RequestBody String jsonInput,
                                                          HttpServletRequest httpRequest, HttpServletResponse httpResponse) {
        JSONObject jsonInputObj = new JSONObject(jsonInput);
        JSONObject jsonResponse = new JSONObject();
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Type", "application/json;charset=utf-8");

        try {
            jsonResponse = authService.verifyOtp(jsonInputObj);
        } catch (Exception e) {
            logger.error("Exception occurred during verifyOtp", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }

        return new ResponseEntity<>(jsonResponse.toString(), headers, HttpStatus.OK);
    }
}
