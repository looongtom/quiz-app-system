package com.example.demo.model.response;

import com.example.demo.entity.QuestionType;
import com.example.demo.model.dto.AnswerDTO;
import lombok.Data;

import java.util.List;

@Data
public class ResponseQuestion {
    private String question;
    private QuestionType type;
    private double time;
    private List<AnswerDTO> answers;
}
