package com.example.demo.model.request;

import com.example.demo.entity.Answer;
import com.example.demo.entity.QuestionType;
import jakarta.annotation.Nullable;
import lombok.Data;

import java.util.List;


@Data
public class QuestionRequestCreateManyByFile {
    @Nullable
    private Integer id;
    private String question;
    @Nullable
    private int quizId;
    private QuestionType type;
    private double time;
    @Nullable
    private List<Answer> answers;


}
