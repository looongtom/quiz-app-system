package com.example.demo.controller;

import com.example.demo.entity.Answer;
import com.example.demo.model.dto.AnswerDTO;
import com.example.demo.model.request.AnswerRequest;
import com.example.demo.model.response.ResponseHandler;
import com.example.demo.model.response.ResponseStatusConstants;
import com.example.demo.service.IAnswerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;
@CrossOrigin(maxAge = 3600)
@RequestMapping("/api/v1/answer")
@RestController
public class AnswerController {
    @Autowired
    private IAnswerService iAnswerService;

    public AnswerController(IAnswerService iAnswerService) {
        this.iAnswerService = iAnswerService;
    }

    @PostMapping("/save-answer")
    public ResponseEntity<Object>saveAnswer(@RequestBody AnswerRequest answerRequest){
        try {
            Answer answer = iAnswerService.saveAnswer(answerRequest);
            return ResponseHandler.generateResponse(ResponseStatusConstants.SUCCESS_MESSAGE,ResponseStatusConstants.SUCCESS_STATUS, answer);
        } catch (Exception e) {
            return ResponseHandler.generateResponse(ResponseStatusConstants.ERROR_INSERT_MESSAGE,ResponseStatusConstants.ERROR_STATUS, null);
        }
    }

    @PostMapping("/update-list-answer")
    public ResponseEntity<Object>updateListAnswer(@RequestBody List<AnswerRequest> answerRequestList){
        try {

            List<Answer> answerList = iAnswerService.updateListAnswer(answerRequestList);
            return ResponseHandler.generateResponse(ResponseStatusConstants.SUCCESS_MESSAGE,ResponseStatusConstants.SUCCESS_STATUS, answerList);
        } catch (Exception e) {
            return ResponseHandler.generateResponse(ResponseStatusConstants.ERROR_INSERT_MESSAGE,ResponseStatusConstants.ERROR_STATUS, null);
        }
    }
}
