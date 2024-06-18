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
import com.tms.services.SprintTaskService;

@RestController
public class SprintTaskController {

    private static final Logger logger = LoggerFactory.getLogger(SprintTaskController.class);

    private AuthService as = new AuthService();
    private SprintTaskService sts = new SprintTaskService();

    @RequestMapping(value = "/addSprintTask", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> addSprintTask(
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
            jsonResponse = sts.addSprintTask(jsonInputObj);
        } catch (Exception e) {
        	e.printStackTrace();
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), headers, HttpStatus.OK);
    }
    
    @RequestMapping(value = "/listSprintTask", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> listSprintTask(
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
            jsonResponse = sts.listSprintTask(jsonInputObj);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), headers, HttpStatus.OK);
    }
}
