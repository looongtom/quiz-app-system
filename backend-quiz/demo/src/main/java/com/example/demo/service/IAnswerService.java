package com.example.demo.service;

import com.example.demo.entity.Answer;
import com.example.demo.model.dto.AnswerDTO;
import com.example.demo.model.request.AnswerRequest;

import java.util.List;

public interface IAnswerService {

    Answer saveAnswer(AnswerRequest answerRequest);

    List<Answer> updateListAnswer(List<AnswerRequest> answerRequestList);

}
