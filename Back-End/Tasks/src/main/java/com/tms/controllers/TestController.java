package com.tms.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.tms.services.TestService;

@RestController
public class TestController {

    private final TestService testService = new TestService();



    @RequestMapping(value = "/sum", method = RequestMethod.POST)
    public @ResponseBody ResponseEntity<String> calculateSum(@RequestBody String jsonInput,
                                                             HttpServletRequest httpRequest, HttpServletResponse httpResponse) throws JSONException {
        JSONObject jsonInputObj = new JSONObject(jsonInput);
        JSONObject jsonResponse = new JSONObject();

        try {
            int num1 = jsonInputObj.getInt("num1");
            int num2 = jsonInputObj.getInt("num2");
            int sum = testService.calculateSum(num1, num2);
            jsonResponse.put("sum", sum);
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("error", "Exception occurred during calculateSum");
            return new ResponseEntity<>(jsonResponse.toString(), HttpStatus.INTERNAL_SERVER_ERROR);
        }

        return new ResponseEntity<>(jsonResponse.toString(), HttpStatus.OK);
    }
}
