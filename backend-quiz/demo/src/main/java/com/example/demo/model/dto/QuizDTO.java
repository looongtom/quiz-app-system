package com.example.demo.model.dto;

import com.example.demo.entity.PrivacyQuizType;
import jakarta.annotation.Nullable;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class QuizDTO {
    @Nullable
    private Integer id;
    private String name;
    private LocalDateTime startAt;
    private LocalDateTime expireAt;
    private PrivacyQuizType privacy;
}
