package com.example.authorizequiz.controller;

import com.example.authorizequiz.model.dto.PermissionQuizDTO;
import com.example.authorizequiz.model.response.ResponseHandler;
import com.example.authorizequiz.model.response.ResponseStatusConstants;
import com.example.authorizequiz.service.IPermissionQuizService;
import org.apache.coyote.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(maxAge = 3600)
@RequestMapping("/api/v1/permission-quiz")
@RestController
public class PermissionController {

    @Autowired
    private IPermissionQuizService permissionService;

    public PermissionController(IPermissionQuizService permissionService) {
        this.permissionService = permissionService;
    }

    @PostMapping("/add")
    public ResponseEntity<Object>addPermissionForQuiz(@RequestBody PermissionQuizDTO permissionQuizDTO){
        return ResponseHandler.generateResponse("Permission added successfully", ResponseStatusConstants.SUCCESS_STATUS, permissionService.addPermissionForQuiz(permissionQuizDTO));
    }

    @GetMapping("/check-permission")
    public ResponseEntity<Object> checkPermission(@RequestParam int userId, @RequestParam int quizId){
        if(permissionService.checkPermission(userId, quizId)){
            return ResponseHandler.generateResponse("User can access this quiz", ResponseStatusConstants.SUCCESS_STATUS, true);
        }
        return ResponseHandler.generateResponse("User cannot access this quiz", ResponseStatusConstants.SUCCESS_STATUS, false);
    }

    @DeleteMapping("/delete")
    public ResponseEntity<Object> deletePermission(@RequestParam int userId, @RequestParam int quizId){
        try{
            Boolean check =permissionService.deletePermission(userId, quizId);
            if(check){
                return ResponseHandler.generateResponse("Permission deleted successfully", ResponseStatusConstants.SUCCESS_STATUS, check);
            }
            return ResponseHandler.generateResponse("Permission deleted unsuccessfully", ResponseStatusConstants.SUCCESS_STATUS, check);
        }catch (Exception e){
            return ResponseHandler.generateResponse("Permission deleted unsuccessfully", ResponseStatusConstants.ERROR_STATUS, null);
        }
    }
}
