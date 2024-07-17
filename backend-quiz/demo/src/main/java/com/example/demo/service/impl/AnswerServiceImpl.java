package com.example.demo.service.impl;

import com.example.demo.entity.Answer;
import com.example.demo.entity.Question;
import com.example.demo.model.dto.AnswerDTO;
import com.example.demo.model.dto.QuestionDTO;
import com.example.demo.model.request.AnswerRequest;
import com.example.demo.repository.AnswerRepository;
import com.example.demo.repository.QuestionRepository;
import com.example.demo.service.IAnswerService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class AnswerServiceImpl implements IAnswerService {
    @Autowired
    private AnswerRepository answerRepository;
    @Autowired
    private QuestionRepository questionRepository;
    private ModelMapper modelMapper = new ModelMapper();

    public AnswerServiceImpl(AnswerRepository answerRepository, QuestionRepository questionRepository) {
        this.answerRepository = answerRepository;
        this.questionRepository = questionRepository;
    }


    @Override
    public Answer saveAnswer(AnswerRequest answerRequest) {
        Answer answer = modelMapper.map(answerRequest, Answer.class);
        Question question = questionRepository.findById(answerRequest.getQuestionId()).get();
        answer.setQuestion(question);
        return answerRepository.save(answer);

    }

    @Override
    public List<Answer> updateListAnswer(List<AnswerRequest> answerRequestList) {
        List<Answer> answerList = new ArrayList<>();
        for (AnswerRequest answerRequest : answerRequestList) {
            Answer answer = modelMapper.map(answerRequest, Answer.class);
            Question question = questionRepository.findById(answerRequest.getQuestionId()).get();
            answer.setQuestion(question);
            answerList.add(answer);
        }
        return answerRepository.saveAll(answerList);
    }
}
