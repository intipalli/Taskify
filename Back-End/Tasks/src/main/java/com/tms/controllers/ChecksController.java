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
import com.tms.services.CheckService;
import com.tms.services.UserService;

@RestController
public class ChecksController {

    private static final Logger logger = LoggerFactory.getLogger(ChecksController.class);

    private AuthService authService = new AuthService();
    private UserService userService = new UserService();
    private CheckService checkService = new CheckService();

    @RequestMapping(value = "/isUserAvailable", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> isUserAvailable(@RequestBody String jsonInput,
                                                                HttpServletRequest httpRequest, HttpServletResponse httpResponse) {
        JSONObject jsonInputObj = new JSONObject(jsonInput);
        JSONObject jsonResponse = new JSONObject();

        try {
            if (!checkService.checkUsername(jsonInputObj.getString("userName"))) {
                jsonResponse.put("Exist", "No");
            } else {
                jsonResponse.put("Exist", "Yes");
            }
            return new ResponseEntity<>(jsonResponse.toString(), HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Exception occurred in isUserAvailable", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @RequestMapping(value = "/isUserActive/{username}", method = RequestMethod.GET)
    public @ResponseBody ResponseEntity<String> isUserActive(@PathVariable String username,
                                                             HttpServletRequest httpRequest, HttpServletResponse httpResponse) {
        JSONObject jsonResponse = new JSONObject();
        HttpHeaders header = new HttpHeaders();
        header.add("Content-Type", "application/json;charset=utf-8");

        try {
            jsonResponse = userService.getUserStatus(username);
            return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Exception occurred in isUserActive", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @RequestMapping(value = "/isEmailValid", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> isEmailValid(@RequestHeader(value = "token") String token, @RequestBody String jsonInput,
                                                             HttpServletRequest httpRequest, HttpServletResponse httpResponse) {
        JSONObject jsonInputObj = new JSONObject(jsonInput);
        JSONObject jsonResponse = new JSONObject();
        HttpHeaders header = new HttpHeaders();
        header.add("Content-Type", "application/json;charset=utf-8");
        header.add("token", token);

        try {
            if (!authService.tokenChecker(token)) {
                jsonResponse.put("errorType", "TOKEN_NOT_VALID");
                return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.BAD_REQUEST);
            }
            jsonResponse = checkService.isEmailValid(jsonInputObj);
            return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Exception occurred in isEmailValid", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @RequestMapping(value = "/isTaskAvailable", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> isTaskAvailable(@RequestHeader(value = "token") String token, @RequestBody String jsonInput,
                                                                HttpServletRequest httpRequest, HttpServletResponse httpResponse) {
        JSONObject jsonInputObj = new JSONObject(jsonInput);
        JSONObject jsonResponse = new JSONObject();
        HttpHeaders header = new HttpHeaders();
        header.add("Content-Type", "application/json;charset=utf-8");
        header.add("token", token);

        try {
            if (!authService.tokenChecker(token)) {
                jsonResponse.put("errorType", "TOKEN_NOT_VALID");
                return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.BAD_REQUEST);
            }
            jsonResponse = checkService.isTaskAvailable(jsonInputObj);
            return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Exception occurred in isTaskAvailable", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @RequestMapping(value = "/userTaskStatusCheck", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> userTaskStatusCheck(@RequestHeader(value = "token") String token, @RequestBody String jsonInput,
                                                                    HttpServletRequest httpRequest, HttpServletResponse httpResponse) {
        JSONObject jsonInputObj = new JSONObject(jsonInput);
        JSONObject jsonResponse = new JSONObject();
        HttpHeaders header = new HttpHeaders();
        header.add("Content-Type", "application/json;charset=utf-8");
        header.add("token", token);

        try {
            if (!authService.tokenChecker(token)) {
                jsonResponse.put("errorType", "TOKEN_NOT_VALID");
                return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.BAD_REQUEST);
            }
            jsonResponse = checkService.userTaskStatusCheck(jsonInputObj);
            return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Exception occurred in userTaskStatusCheck", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @RequestMapping(value = "/isSprintAvailable", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> isSprintAvailable(@RequestHeader(value = "token") String token, @RequestBody String jsonInput,
                                                                  HttpServletRequest httpRequest, HttpServletResponse httpResponse) {
        JSONObject jsonInputObj = new JSONObject(jsonInput);
        JSONObject jsonResponse = new JSONObject();
        HttpHeaders header = new HttpHeaders();
        header.add("Content-Type", "application/json;charset=utf-8");
        header.add("token", token);

        try {
            if (!authService.tokenChecker(token)) {
                jsonResponse.put("errorType", "TOKEN_NOT_VALID");
                return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.BAD_REQUEST);
            }
            jsonResponse = checkService.isSprintAvailable(jsonInputObj);
            return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Exception occurred in isSprintAvailable", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @RequestMapping(value = "/sprintCheck/{sprintId}", method = RequestMethod.GET)
    public @ResponseBody ResponseEntity<String> sprintCheck(@RequestHeader(value = "token") String token, @PathVariable int sprintId,
                                                            HttpServletRequest httpRequest, HttpServletResponse httpResponse) {
        JSONObject jsonResponse = new JSONObject();
        HttpHeaders header = new HttpHeaders();
        header.add("Content-Type", "application/json;charset=utf-8");
        header.add("token", token);

        try {
            if (!authService.tokenChecker(token)) {
                jsonResponse.put("errorType", "TOKEN_NOT_VALID");
                return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.BAD_REQUEST);
            }
            jsonResponse = checkService.sprintCheck(sprintId);
            return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Exception occurred in sprintCheck", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
