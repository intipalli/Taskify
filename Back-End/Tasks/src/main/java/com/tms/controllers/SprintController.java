package com.tms.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.tms.services.AuthService;
import com.tms.services.SprintService;

@RestController
public class SprintController {

    private static final Logger logger = LoggerFactory.getLogger(SprintController.class);

    private SprintService ss = new SprintService();
    private AuthService as = new AuthService();


    @RequestMapping(value = "/sprint", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> addSprint(
            @RequestHeader(value = "token") String token,
            @RequestBody String jsonInput,
            HttpServletRequest httpRequest,
            HttpServletResponse httpResponse) {

        JSONObject jsonInputObj = new JSONObject(jsonInput);
        JSONObject jsonResponse = new JSONObject();
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Type", "application/json;charset=utf-8");
        headers.add("token", token);

        try {
            if (!as.tokenChecker(token)) {
                jsonResponse.put("errorType", "TOKEN_NOT_VALID");
                return new ResponseEntity<>(jsonResponse.toString(), headers, HttpStatus.BAD_REQUEST);
            }
            jsonResponse = ss.addSprint(jsonInputObj);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), headers, HttpStatus.OK);
    }

    @RequestMapping(value = "/sprint/{sprintId}", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> updateSprint(
            @PathVariable int sprintId,
            @RequestBody String jsonInput,
            HttpServletRequest httpRequest,
            HttpServletResponse httpResponse) {

        JSONObject jsonInputObj = new JSONObject(jsonInput);
        JSONObject jsonResponse = new JSONObject();
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Type", "application/json;charset=utf-8");

        try {
            jsonResponse = ss.updateSprint(jsonInputObj, sprintId);
        } catch (Exception e) {
        	e.printStackTrace();
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), headers, HttpStatus.OK);
    }

    @RequestMapping(value = "/fetchSprint", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> fetchSprint(
            @RequestHeader(value = "token") String token,
            @RequestBody String jsonInput,
            HttpServletRequest httpRequest,
            HttpServletResponse httpResponse) {

        JSONObject jsonInputObj = new JSONObject(jsonInput);
        JSONObject jsonResponse = new JSONObject();
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Type", "application/json;charset=utf-8");
        headers.add("token", token);

        try {
            if (!as.tokenChecker(token)) {
                jsonResponse.put("errorType", "TOKEN_NOT_VALID");
                return new ResponseEntity<>(jsonResponse.toString(), headers, HttpStatus.BAD_REQUEST);
            }
            jsonResponse = ss.fetchSprint(jsonInputObj);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), headers, HttpStatus.OK);
    }

    @RequestMapping(value = "/updateSprintStatus/{sprintId}", method = RequestMethod.GET)
    public @ResponseBody ResponseEntity<String> updateSprintStatus(
            @RequestHeader(value = "token") String token,
            @PathVariable int sprintId,
            HttpServletRequest httpRequest,
            HttpServletResponse httpResponse) {

        JSONObject jsonResponse = new JSONObject();
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Type", "application/json;charset=utf-8");
        headers.add("token", token);

        try {
            if (!as.tokenChecker(token)) {
                jsonResponse.put("errorType", "TOKEN_NOT_VALID");
                return new ResponseEntity<>(jsonResponse.toString(), headers, HttpStatus.BAD_REQUEST);
            }
            jsonResponse = ss.updateSprintStatus(sprintId);
        } catch (Exception e) {
            logger.error("Exception occurred while updating sprint status", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), headers, HttpStatus.OK);
    }
}
