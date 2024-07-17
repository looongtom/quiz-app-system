package com.example.authorizequiz.service;

import com.example.authorizequiz.entity.PermissionQuiz;
import com.example.authorizequiz.model.dto.PermissionQuizDTO;

import java.util.List;

public interface IPermissionQuizService {
    List<PermissionQuiz> addPermissionForQuiz(PermissionQuizDTO permissionQuizDTO);
    Boolean checkPermission(int userId,int quizId);

    Boolean deletePermission(int userId,int quizId);
}
