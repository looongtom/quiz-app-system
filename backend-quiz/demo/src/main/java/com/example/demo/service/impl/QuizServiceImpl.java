package com.example.demo.service.impl;

import com.example.demo.entity.Quiz;
import com.example.demo.model.dto.QuizDTO;
import com.example.demo.model.request.QuizRequest;
import com.example.demo.model.request.QuizRequestCreateByFile;
import com.example.demo.repository.QuizRepository;
import com.example.demo.service.IQuizService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class QuizServiceImpl implements IQuizService {

    @Autowired
    private QuizRepository quizRepository;

    private ModelMapper modelMapper=new ModelMapper();

    public QuizServiceImpl(QuizRepository quizRepository) {
        this.quizRepository = quizRepository;
    }

    @Override
    public List<QuizDTO> getAllQuiz() {
        List<Quiz> quizList = quizRepository.findAll();
        List<QuizDTO>quizDTOList= new ArrayList<>();
        for (Quiz tmp :
                quizList) {
            QuizDTO quizDTO = modelMapper.map(tmp, QuizDTO.class);
            quizDTOList.add(quizDTO);
        }
        return quizDTOList;
    }

    @Override
    public Quiz saveQuiz(QuizRequest quizRequest) {
        Quiz quiz;
        if (quizRequest.getId() != null && quizRepository.existsById(quizRequest.getId())) {
            quiz = quizRepository.findById(quizRequest.getId()).get();

            if(quizRequest.getId()==null)
                quizRequest.setId(quiz.getId());

            if(quizRequest.getName()==null)
                quizRequest.setName(quiz.getName());

            if(quizRequest.getPrivacy()==null)
                quizRequest.setPrivacy(quiz.getPrivacy());

            if(quizRequest.getStartAt()==null)
                quizRequest.setStartAt(quiz.getStartAt());

            if(quizRequest.getExpireAt()==null)
                quizRequest.setExpireAt(quiz.getExpireAt());

        } else {
            quiz = modelMapper.map(quizRequest, Quiz.class);
        }
        return quizRepository.save(quiz);
    }

    @Override
    public Quiz saveQuizMany(QuizRequestCreateByFile quizRequest) {
        Quiz quiz;
        if (quizRequest.getId() != null && quizRepository.existsById(quizRequest.getId())) {
            quiz = quizRepository.findById(quizRequest.getId()).get();
            modelMapper.map(quizRequest, quiz);
        } else {
            quiz = modelMapper.map(quizRequest, Quiz.class);
        }
        return quizRepository.save(quiz);
    }

    @Override
    public Quiz saveQuizManyInternal(QuizRequest quizRequest) {
        Quiz quiz;
        if (quizRequest.getId() != null && quizRepository.existsById(quizRequest.getId())) {
            quiz = quizRepository.findById(quizRequest.getId()).get();
            modelMapper.map(quizRequest, quiz);
        } else {
            quiz = modelMapper.map(quizRequest, Quiz.class);
        }
        return quizRepository.save(quiz);
    }

    @Override
    public Page<QuizDTO> searchQuiz(Pageable pageable,String search) {
        Page<Quiz> quizList = null;
        if(search==null || search.equals("")){
            quizList=quizRepository.findAll(pageable);
        }
        else{
            quizList=quizRepository.findQuizByNameContainingIgnoreCase(pageable,search);
        }

        return quizList.map(quiz -> modelMapper.map(quiz, QuizDTO.class));
    }

    @Override
    public QuizDTO getQuizById(int id) {
        Quiz quiz = quizRepository.findById(id).get();
        QuizDTO quizDTO = modelMapper.map(quiz, QuizDTO.class);
        return quizDTO;
    }

}
