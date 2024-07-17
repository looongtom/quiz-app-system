package com.example.demo.model.request;

import com.example.demo.entity.Answer;
import com.example.demo.entity.QuestionType;
import jakarta.annotation.Nullable;
import lombok.Data;

import java.util.List;

@Data
public class QuestionUpdateRequest {
    @Nullable
    private Integer id;
    private String question;
    private int quizId;
    private QuestionType type;
    private double time;
    private List<AnswerRequest> answers;
}
