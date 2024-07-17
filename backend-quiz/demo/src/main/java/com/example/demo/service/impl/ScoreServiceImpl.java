package com.example.demo.service.impl;

import com.example.demo.entity.Quiz;
import com.example.demo.entity.Score;
import com.example.demo.model.dto.ScoreDTO;
import com.example.demo.model.request.ScoreRequest;
import com.example.demo.repository.QuizRepository;
import com.example.demo.repository.ScoreRepository;
import com.example.demo.service.IScoreService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ScoreServiceImpl implements IScoreService {

    @Autowired
    private ScoreRepository scoreRepository;
    @Autowired
    private QuizRepository quizRepository;

    private ModelMapper modelMapper = new ModelMapper();

    public ScoreServiceImpl(ScoreRepository scoreRepository, QuizRepository quizRepository) {
        this.scoreRepository = scoreRepository;
        this.quizRepository = quizRepository;
    }

    @Override
    public Score saveScore(ScoreRequest scoreRequest) {
        Score score=modelMapper.map(scoreRequest,Score.class);
        Quiz quiz=quizRepository.findQuizById(scoreRequest.getQuizId());
        score.setQuiz(quiz);
        return scoreRepository.save(score);
    }

    @Override
    public List<ScoreDTO> getScoreByQuiz(int quizId) {
        List<Score>scoreList=scoreRepository.findByQuizIdOrderByTimestampDesc(quizId);
        List<ScoreDTO> scoreDTOS=new ArrayList<>();
        for(Score tmp:scoreList){
            ScoreDTO scoreDTO=modelMapper.map(tmp,ScoreDTO.class);
            scoreDTO.setQuizId(tmp.getQuiz().getId());
            scoreDTO.setQuizName(tmp.getQuiz().getName());
            scoreDTOS.add(scoreDTO);
        }
        return scoreDTOS;
    }

    @Override
    public List<ScoreDTO> getScoreByUser(int quizId) {
        List<Score>scoreList=scoreRepository.findByUserIdOrderByTimestampDesc(quizId);
        List<ScoreDTO> scoreDTOS=new ArrayList<>();
        for(Score tmp:scoreList){
            ScoreDTO scoreDTO=modelMapper.map(tmp,ScoreDTO.class);
            scoreDTO.setQuizId(tmp.getQuiz().getId());
            scoreDTO.setQuizName(tmp.getQuiz().getName());
            scoreDTOS.add(scoreDTO);
        }
        return scoreDTOS;
    }

    @Override
    public Page<ScoreDTO> searchScoreByQuiz(Pageable pageable, Integer quizId) {
        Page<Score> scoreList=null;
        if(quizId==null) {
            scoreList = scoreRepository.findAll(pageable);
        }
        else{
            scoreList=scoreRepository.findByQuizIdOrderByTimestampDesc(pageable,quizId);
        }
        return scoreList.map(score -> {
            ScoreDTO scoreDTO=modelMapper.map(score,ScoreDTO.class);
            scoreDTO.setQuizId(score.getQuiz().getId());
            scoreDTO.setQuizName(score.getQuiz().getName());
            return scoreDTO;
        });
    }

    @Override
    public Page<ScoreDTO> searchScoreByUser(Pageable pageable, Integer userId) {
        Page<Score> scoreList=null;
        if(userId==null) {
            scoreList = scoreRepository.findAll(pageable);
        }
        else{
            scoreList=scoreRepository.findByUserIdOrderByTimestampDesc(pageable,userId);
        }
        return scoreList.map(score -> {
            ScoreDTO scoreDTO=modelMapper.map(score,ScoreDTO.class);
            scoreDTO.setQuizId(score.getQuiz().getId());
            scoreDTO.setQuizName(score.getQuiz().getName());
            return scoreDTO;
        });
    }
}
