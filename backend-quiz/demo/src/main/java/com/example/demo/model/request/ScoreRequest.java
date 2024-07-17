package com.example.demo.model.request;

import com.example.demo.entity.Quiz;
import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.annotation.Nullable;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.FetchType;
import jakarta.persistence.ManyToOne;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ScoreRequest {
    @Nullable
    private Integer id;
    private double score;
    @Nullable
    private LocalDateTime timestamp = LocalDateTime.now();
    private Integer quizId;
    private Integer userId;
    private String username;
}
