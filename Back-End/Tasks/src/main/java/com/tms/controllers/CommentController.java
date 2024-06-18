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
import com.tms.services.CommentsService;

@RestController
public class CommentController {

    private static final Logger logger = LoggerFactory.getLogger(CommentController.class);

    private AuthService authService = new AuthService();
    private CommentsService commentsService = new CommentsService();


    @RequestMapping(value = "/addComment", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> addComment(
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
            if (!authService.tokenChecker(token)) {
                jsonResponse.put("errorType", "TOKEN_NOT_VALID");
                return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.BAD_REQUEST);
            }

            jsonResponse = commentsService.addComments(jsonInputObj);
        } catch (Exception e) {
            logger.error("Exception occurred while adding comment", e);
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.OK);
    }

    @RequestMapping(value = "/editComment", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> editComments(
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
            if (!authService.tokenChecker(token)) {
                jsonResponse.put("errorType", "TOKEN_NOT_VALID");
                return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.BAD_REQUEST);
            }

            jsonResponse = commentsService.editComments(jsonInputObj);
        } catch (Exception e) {
        	e.printStackTrace();
        	return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.OK);
    }

    @RequestMapping(value = "/deleteComment", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> deleteComment(
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
            if (!authService.tokenChecker(token)) {
                jsonResponse.put("errorType", "TOKEN_NOT_VALID");
                return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.BAD_REQUEST);
            }

            jsonResponse = commentsService.deleteComment(jsonInputObj);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Exception Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(jsonResponse.toString(), header, HttpStatus.OK);
    }
}
