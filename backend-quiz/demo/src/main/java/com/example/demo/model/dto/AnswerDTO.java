package com.example.demo.model.dto;

import jakarta.annotation.Nullable;
import lombok.Data;


@Data
public class AnswerDTO {
    @Nullable
    private int id;
    private String name;
    private boolean isCorrect=false;

}
