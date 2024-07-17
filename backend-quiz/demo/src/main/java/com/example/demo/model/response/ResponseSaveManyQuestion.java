package com.example.demo.model.response;

import lombok.Data;

import java.util.List;

@Data
public class ResponseSaveManyQuestion {
    String quizzName;
    List<ResponseQuestion> questions;
}
