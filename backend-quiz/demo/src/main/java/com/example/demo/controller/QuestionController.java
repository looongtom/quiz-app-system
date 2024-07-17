package com.example.demo.controller;


import com.example.demo.entity.Question;
import com.example.demo.model.dto.QuestionDTO;
import com.example.demo.model.request.QuestionQuizRequestCreateMany;
import com.example.demo.model.request.QuestionRequest;
import com.example.demo.model.request.QuestionRequestCreateMany;
import com.example.demo.model.request.QuestionRequestCreateManyByFile;
import com.example.demo.model.response.ResponseGetManyQuestion;
import com.example.demo.model.response.ResponseHandler;
import com.example.demo.model.response.ResponseSaveManyQuestion;
import com.example.demo.model.response.ResponseStatusConstants;
import com.example.demo.service.IQuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.List;
@CrossOrigin(maxAge = 3600)
@RequestMapping("/api/v1/question")
@RestController
public class QuestionController {

    @Autowired
    private IQuestionService iQuestionService;
    @Value("${sse.server}")
    private String SSE_SERVER;
    public QuestionController(IQuestionService iQuestionService) {
        this.iQuestionService = iQuestionService;
    }

    @GetMapping("/get-all-question")
    public ResponseEntity<Object> getAllQuestion(){
       try{
           List<QuestionDTO> questionDTOList = iQuestionService.getAllQuestion();
           return ResponseHandler.generateResponse(ResponseStatusConstants.SUCCESS_MESSAGE,ResponseStatusConstants.SUCCESS_STATUS,questionDTOList );
       }catch (Exception e){
           return ResponseHandler.generateResponse(ResponseStatusConstants.ERROR_GET_MESSAGE,ResponseStatusConstants.ERROR_STATUS,e.getMessage());
       }

    }

    @PostMapping("/save-question")
    public ResponseEntity<Object>saveQuestion( @RequestBody QuestionRequest questionRequest){
        try{
            Question question = iQuestionService.saveQuestion(questionRequest);
            return ResponseHandler.generateResponse(ResponseStatusConstants.SUCCESS_MESSAGE,ResponseStatusConstants.SUCCESS_STATUS, question);
        }catch (Exception e){
            return ResponseHandler.generateResponse(ResponseStatusConstants.ERROR_INSERT_MESSAGE,ResponseStatusConstants.ERROR_STATUS,e.getMessage());
        }

    }
    @PostMapping("/update-question")
    public ResponseEntity<Object>updateQuestion( @RequestBody QuestionRequestCreateManyByFile questionRequest){
        try{
            Question question = iQuestionService.updateQuestion(questionRequest);
            return ResponseHandler.generateResponse(ResponseStatusConstants.SUCCESS_MESSAGE,ResponseStatusConstants.SUCCESS_STATUS, question);
        }catch (Exception e){
            return ResponseHandler.generateResponse(ResponseStatusConstants.ERROR_INSERT_MESSAGE,ResponseStatusConstants.ERROR_STATUS,e.getMessage());
        }

    }
    @GetMapping("/get-question-by-id")
    public ResponseEntity<Object>getSingleQuestion( @RequestParam int questionId){
        try{
            QuestionDTO question = iQuestionService.getQuestionById(questionId);
            return ResponseHandler.generateResponse(ResponseStatusConstants.SUCCESS_MESSAGE,ResponseStatusConstants.SUCCESS_STATUS, question);
        }catch (Exception e){
            return ResponseHandler.generateResponse(ResponseStatusConstants.ERROR_INSERT_MESSAGE,ResponseStatusConstants.ERROR_STATUS,e.getMessage());
        }

    }

    @PostMapping("/save-many-question-by-file")
    public ResponseEntity<Object>saveManyQuestion(
            @RequestBody QuestionRequestCreateMany questionRequestList){
        try{
            ResponseSaveManyQuestion responseSaveManyQuestion = iQuestionService.saveManyQuestionByFile(questionRequestList);
            return ResponseHandler.generateResponse(ResponseStatusConstants.SUCCESS_MESSAGE, ResponseStatusConstants.SUCCESS_STATUS, responseSaveManyQuestion);
        }catch (Exception e){
            return ResponseHandler.generateResponse(ResponseStatusConstants.ERROR_INSERT_MESSAGE,ResponseStatusConstants.ERROR_STATUS,e.getMessage());
        }

    }

    @PostMapping("/save-many-question")
    public ResponseEntity<Object>saveManyQuestion(
            @RequestBody QuestionQuizRequestCreateMany questionRequestList){
        RestTemplate restTemplate = new RestTemplate();
        try{
//            to send message to all subscribers
            ResponseSaveManyQuestion responseSaveManyQuestion = iQuestionService.saveManyQuestion(questionRequestList);
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            restTemplate.getForObject("http://" +SSE_SERVER+":8083/send-message?message=Service question runs successfully", String.class);
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            return ResponseHandler.generateResponse(ResponseStatusConstants.SUCCESS_MESSAGE, ResponseStatusConstants.SUCCESS_STATUS, responseSaveManyQuestion);
        }catch (Exception e){
            restTemplate.getForObject("http://" +SSE_SERVER+":8083/send-message?message=Error creating questions", String.class);
            return ResponseHandler.generateResponse(ResponseStatusConstants.ERROR_INSERT_MESSAGE,ResponseStatusConstants.ERROR_STATUS,e.getMessage());
        }

    }

    @GetMapping("/get-question-by-quiz")
    public  ResponseEntity<Object> getQuestionByQuiz(@RequestParam int quizId){
        try{
            ResponseGetManyQuestion responseQuestions = iQuestionService.getQuestionByQuiz(quizId);
            return ResponseHandler.generateResponse(ResponseStatusConstants.SUCCESS_MESSAGE, ResponseStatusConstants.SUCCESS_STATUS, responseQuestions);
        }catch (Exception e){
            return ResponseHandler.generateResponse(e.getMessage(),ResponseStatusConstants.ERROR_STATUS,null);
        }
    }

}
