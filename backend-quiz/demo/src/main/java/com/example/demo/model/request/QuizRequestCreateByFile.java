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
public class QuizRequestCreateByFile {
    @Nullable
    private Integer id;
    private String name;
    private PrivacyQuizType privacy=PrivacyQuizType.PUBLIC;
    private LocalDateTime startAt;
    private LocalDateTime expireAt;
    public QuizRequestCreateByFile(String name) {
        this.name = name;
    }
    public QuizRequestCreateByFile(String name, PrivacyQuizType privacy, LocalDateTime startAt, LocalDateTime expireAt) {
        this.name = name;
        this.privacy = privacy;
        this.startAt = startAt;
        this.expireAt = expireAt;
    }
}
