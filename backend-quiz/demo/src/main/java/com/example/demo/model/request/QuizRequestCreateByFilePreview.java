package com.example.demo.model.request;

import com.example.demo.entity.PrivacyQuizType;
import jakarta.annotation.Nullable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QuizRequestCreateByFilePreview {
    private String name;
    private PrivacyQuizType privacy=PrivacyQuizType.PUBLIC;
    private LocalDateTime startAt;
    private LocalDateTime expireAt;
    public QuizRequestCreateByFilePreview(String name) {
        this.name = name;
    }



}
