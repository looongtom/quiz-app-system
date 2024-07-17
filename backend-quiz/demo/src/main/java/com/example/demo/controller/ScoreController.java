package com.example.demo.controller;

import com.example.demo.entity.Score;
import com.example.demo.model.dto.ScoreDTO;
import com.example.demo.model.request.ScoreRequest;
import com.example.demo.model.response.PaginationResponse;
import com.example.demo.model.response.ResponseHandler;
import com.example.demo.model.response.ResponseStatusConstants;
import com.example.demo.service.IScoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
@CrossOrigin(maxAge = 3600)
@RequestMapping("/api/v1/score")
@RestController
public class ScoreController {

    @Autowired
    private IScoreService iScoreService;

    public ScoreController(IScoreService iScoreService) {
        this.iScoreService = iScoreService;
    }

    @PostMapping("/save-score")
    public ResponseEntity<Object>saveScore(@RequestBody ScoreRequest scoreRequest){
        return ResponseHandler.generateResponse(ResponseStatusConstants.SUCCESS_MESSAGE,ResponseStatusConstants.SUCCESS_STATUS, iScoreService.saveScore(scoreRequest));
    }

    @GetMapping("/get-score-by-quiz")
    public ResponseEntity<Object> getScoreByQuiz(@RequestParam int quizId){
        return ResponseHandler.generateResponse(ResponseStatusConstants.SUCCESS_MESSAGE,ResponseStatusConstants.SUCCESS_STATUS, iScoreService.getScoreByQuiz(quizId));
    }
    @GetMapping("/search-score-by-quiz")
    public ResponseEntity<Object> searchScoreByQuiz(
            @RequestParam Integer quizId,
            @RequestParam (defaultValue = "0") Integer pageNo,
            @RequestParam (defaultValue = "5") Integer pageSize){
        Pageable pageable= PageRequest.of(pageNo, pageSize);
        Page<ScoreDTO> scoreDTOS=iScoreService.searchScoreByQuiz(pageable,quizId);
        PaginationResponse paginationResponse = new PaginationResponse();
        paginationResponse.setTotalPage(scoreDTOS.getTotalPages());
        paginationResponse.setTotalItem(scoreDTOS.getTotalElements());
        paginationResponse.setCurrentPage(pageNo);
        paginationResponse.setItemPerPage(pageSize);
        paginationResponse.setData(scoreDTOS.getContent());
        paginationResponse.setSearch(quizId.toString());

        return ResponseHandler.generateResponse(ResponseStatusConstants.SUCCESS_MESSAGE,ResponseStatusConstants.SUCCESS_STATUS, paginationResponse);
    }

    @GetMapping("/get-score-by-user")
    public ResponseEntity<Object> getScoreByUser(@RequestParam int userId){
        return ResponseHandler.generateResponse(ResponseStatusConstants.SUCCESS_MESSAGE,ResponseStatusConstants.SUCCESS_STATUS, iScoreService.getScoreByUser(userId));
    }

    @GetMapping("/search-score-by-user")
    public ResponseEntity<Object> searchScoreByUser(
            @RequestParam Integer userId,
            @RequestParam (defaultValue = "0") Integer pageNo,
            @RequestParam (defaultValue = "5") Integer pageSize){
        Pageable pageable= PageRequest.of(pageNo, pageSize);
        Page<ScoreDTO> scoreDTOS=iScoreService.searchScoreByUser(pageable,userId);
        PaginationResponse paginationResponse = new PaginationResponse();
        paginationResponse.setTotalPage(scoreDTOS.getTotalPages());
        paginationResponse.setTotalItem(scoreDTOS.getTotalElements());
        paginationResponse.setCurrentPage(pageNo);
        paginationResponse.setItemPerPage(pageSize);
        paginationResponse.setData(scoreDTOS.getContent());
        paginationResponse.setSearch(userId.toString());
        return ResponseHandler.generateResponse(ResponseStatusConstants.SUCCESS_MESSAGE,ResponseStatusConstants.SUCCESS_STATUS, paginationResponse);
    }
}
