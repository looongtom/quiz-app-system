package com.example.demo.model.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;

@Data
public class QuestionRequestCreateManyPreview {
    List<QuestionRequestCreateManyByFilePreview> listQuestion;
    @JsonProperty("quiz")
    QuizRequestCreateByFilePreview quiz;
}
