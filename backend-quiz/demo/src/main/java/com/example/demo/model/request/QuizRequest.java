package com.example.demo.model.request;

import com.example.demo.entity.PrivacyQuizType;
import jakarta.annotation.Nullable;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class QuizRequest {
    @Nullable
    private Integer id;
    @Nullable
    private String name;
    @Nullable
    private LocalDateTime startAt;
    @Nullable
    private LocalDateTime expireAt;
    @Nullable
    private PrivacyQuizType privacy=PrivacyQuizType.PUBLIC;
    @Nullable
    private List<Integer> listUserId;
}
