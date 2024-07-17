package com.example.demo.model.response;

import lombok.Data;

import java.util.List;

@Data
public class ResponseGetManyQuestion {
    String quizName;
    List<ResponseQuestion> questions;
}
