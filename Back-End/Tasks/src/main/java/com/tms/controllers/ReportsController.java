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
import com.tms.services.ReportsService;

@RestController
public class ReportsController {

    private static final Logger logger = LoggerFactory.getLogger(ReportsController.class);

    private AuthService authService = new AuthService();
    private ReportsService reportsService = new ReportsService();


    @RequestMapping(value = "/taskReport", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> getTaskReport(
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
            if (!authService.tokenChecker(token)) {
                jsonResponse.put("errorType", "TOKEN_NOT_VALID");
                return new ResponseEntity<>(jsonResponse.toString(), headers, HttpStatus.BAD_REQUEST);
            }

            jsonResponse = reportsService.getTaskReport(jsonInputObj);
        } catch (Exception e) {
            logger.error("Exception occurred while fetching task report", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), headers, HttpStatus.OK);
    }
}
