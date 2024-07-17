package com.example.demo.model.request;

import jakarta.annotation.Nullable;
import lombok.Data;


@Data
public class AnswerPreview {
    private String name;
    private Boolean isCorrect=false;

    public AnswerPreview(String name, Boolean isCorrect) {
        this.name = name;
        this.isCorrect = isCorrect;
    }


}
