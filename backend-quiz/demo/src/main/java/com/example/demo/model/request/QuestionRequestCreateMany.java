package com.example.demo.model.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;

@Data
public class QuestionRequestCreateMany {
    List<QuestionRequestCreateManyByFile> listQuestion;
    @JsonProperty("quiz")
    QuizRequestCreateByFile quiz;
}
