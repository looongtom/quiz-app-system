package com.example.demo.model;

import jakarta.annotation.Nullable;
import lombok.Data;

import java.util.List;

@Data
public class PermissionQuizDTO {
    @Nullable
    private Integer id;
    private Integer quizId;
    @Nullable
    private List<Integer> listUserId;

    public PermissionQuizDTO(Integer quizId, List<Integer> listUserId) {
        this.quizId = quizId;
        this.listUserId = listUserId;
    }
}