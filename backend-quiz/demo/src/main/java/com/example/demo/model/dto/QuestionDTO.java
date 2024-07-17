package com.example.demo.model.dto;

import com.example.demo.entity.QuestionType;
import jakarta.persistence.*;
import lombok.Data;

import java.util.List;


@Data
public class QuestionDTO {
    private int id;
    private String question;
    private int quizId;
    private QuestionType type;
    private double time;
    private List<AnswerDTO> answers;
}
