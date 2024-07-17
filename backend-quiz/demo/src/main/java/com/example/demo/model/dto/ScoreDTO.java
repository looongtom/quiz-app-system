package com.example.demo.model.dto;

import jakarta.persistence.Column;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ScoreDTO {
    private int id;
    private double score;
    private LocalDateTime timestamp = LocalDateTime.now();
    private int userId;
    private String username;
    private int quizId;
    private String quizName;
}
