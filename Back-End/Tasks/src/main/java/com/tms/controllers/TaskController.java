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
import com.tms.services.TaskService;

@RestController
public class TaskController {

    private static final Logger logger = LoggerFactory.getLogger(TaskController.class);

    private TaskService ts = new TaskService();
    private AuthService as = new AuthService();


    @RequestMapping(value = "/taskStatus", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> updateTaskStatus(
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

            jsonResponse = ts.updateTaskStatus(jsonInputObj);

        } catch (Exception e) {
            logger.error("Exception occurred while updating task status", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.OK);
    }

    @RequestMapping(value = "/task/{taskId}", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> updateTask(
            @PathVariable String taskId,
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

            jsonResponse = ts.updateTask(jsonInputObj);
        } catch (Exception e) {
            logger.error("Exception occurred while updating task", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.OK);
    }

    @RequestMapping(value = "/taskHistory", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> taskHistory(
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

            jsonResponse = ts.getSpecificTaskHistory(jsonInputObj);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.OK);
    }

    @RequestMapping(value = "/updateCurrentTaskStatus", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> updateCurrentTaskStatus(
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

            jsonResponse = ts.updateCurrentTaskStatus(jsonInputObj);
        } catch (Exception e) {
        	e.printStackTrace();
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.OK);
    }

    @RequestMapping(value = "/task", method = RequestMethod.GET)
    public @ResponseBody ResponseEntity<String> listAllTasks(
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

            jsonResponse = ts.listAllTasks(token);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.OK);
    }
}
