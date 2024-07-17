package com.example.authorizequiz.model.dto;

import jakarta.annotation.Nullable;
import jakarta.persistence.Column;
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
