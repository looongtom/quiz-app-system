package com.example.demo.service;

import com.example.demo.entity.Score;
import com.example.demo.model.dto.ScoreDTO;
import com.example.demo.model.request.ScoreRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface IScoreService {

    Score saveScore(ScoreRequest scoreRequest);

    List<ScoreDTO> getScoreByQuiz(int quizId);
    List<ScoreDTO> getScoreByUser(int userId);

    Page<ScoreDTO> searchScoreByQuiz(Pageable pageable, Integer quizId);

    Page<ScoreDTO> searchScoreByUser(Pageable pageable, Integer userId);


}
