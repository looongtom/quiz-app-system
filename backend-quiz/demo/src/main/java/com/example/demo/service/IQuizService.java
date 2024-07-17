package com.example.demo.service;

import com.example.demo.entity.Quiz;
import com.example.demo.model.dto.QuizDTO;
import com.example.demo.model.request.QuizRequest;
import com.example.demo.model.request.QuizRequestCreateByFile;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface IQuizService {
    List<QuizDTO> getAllQuiz();
    Quiz saveQuiz(QuizRequest quiz);
    Quiz saveQuizMany(QuizRequestCreateByFile quiz);
    Quiz saveQuizManyInternal(QuizRequest quiz);

    Page<QuizDTO> searchQuiz(Pageable pageable,String quizName);
    QuizDTO getQuizById(int id);
}
