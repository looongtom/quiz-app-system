package com.example.demo.model.request;

import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import lombok.Data;


@Data
public class AnswerRequest {
    @Nullable
    private Integer id;
    private String name;
    private Integer questionId;
    @Nullable
    private boolean isCorrect=false;

}
