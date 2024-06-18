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
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.tms.services.AuthService;
import com.tms.services.UserService;

@RestController
public class UserController {

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    private UserService us = new UserService();
    private AuthService as = new AuthService();

    @RequestMapping(value = "/editProfile", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> editProfile(
            @RequestHeader(value = "token") String token,
            @RequestBody String jsonInput,
            HttpServletRequest httpRequest,
            HttpServletResponse httpResponse) {

        JSONObject jsonInputObj = new JSONObject(jsonInput);
        JSONObject jsonResponse = new JSONObject();
        HttpHeaders header = new HttpHeaders();
        header.add("Content-Type", "application/json;charset=utf-8");
        header.add("token", token);

        try {
            Boolean tokenVerify = as.tokenChecker(token);
            if (!tokenVerify) {
                jsonResponse = new JSONObject();
                jsonResponse.put("errorType", "TOKEN_NOT_VALID");
                return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.BAD_REQUEST);
            }

            jsonResponse = us.editProfile(jsonInputObj, token);
        } catch (Exception e) {
            logger.error("Exception occurred while editing profile", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.OK);
    }

    @RequestMapping(value = "/user", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> newUser(
            @RequestBody String jsonInput,
            HttpServletRequest httpRequest,
            HttpServletResponse httpResponse) {

        JSONObject jsonInputObj = new JSONObject(jsonInput);
        JSONObject jsonResponse = new JSONObject();

        try {
            jsonResponse = us.createUser(jsonInputObj);
        } catch (Exception e) {
        	e.printStackTrace();
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), HttpStatus.OK);
    }

    @RequestMapping(value = "/listUser", method = RequestMethod.GET)
    public @ResponseBody ResponseEntity<String> listUser(
            @RequestHeader(value = "token") String token,
            HttpServletRequest httpRequest,
            HttpServletResponse httpResponse) {

        JSONObject jsonResponse = new JSONObject();
        HttpHeaders header = new HttpHeaders();
        header.add("Content-Type", "application/json;charset=utf-8");
        header.add("token", token);

        try {
            Boolean tokenVerify = as.tokenChecker(token);
            if (!tokenVerify) {
                jsonResponse = new JSONObject();
                jsonResponse.put("errorType", "TOKEN_NOT_VALID");
                return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.BAD_REQUEST);
            }

            jsonResponse = us.listUsers(token);
        } catch (Exception e) {
            logger.error("Exception occurred while listing users", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.OK);
    }

    @RequestMapping(value = "/activateInactivateUser", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> activateInactivateUser(
            @RequestHeader(value = "token") String token,
            @RequestBody String jsonInput,
            HttpServletRequest httpRequest,
            HttpServletResponse httpResponse) {

        JSONObject jsonInputObj = new JSONObject(jsonInput);
        JSONObject jsonResponse = new JSONObject();
        HttpHeaders header = new HttpHeaders();
        header.add("Content-Type", "application/json;charset=utf-8");
        header.add("token", token);

        try {
            Boolean tokenVerify = as.tokenChecker(token);
            if (!tokenVerify) {
                jsonResponse = new JSONObject();
                jsonResponse.put("errorType", "TOKEN_NOT_VALID");
                return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.BAD_REQUEST);
            }

            jsonResponse = us.setUserStatus(jsonInputObj);
        } catch (Exception e) {
            logger.error("Exception occurred while activating/inactivating user", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.OK);
    }
}
