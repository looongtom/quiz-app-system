package com.example.demo.service.impl;

import com.example.demo.controller.QuizController;
import com.example.demo.entity.Question;
import com.example.demo.entity.Quiz;
import com.example.demo.model.dto.QuestionDTO;
import com.example.demo.model.dto.QuizDTO;
import com.example.demo.model.request.*;
import com.example.demo.model.response.ResponseGetManyQuestion;
import com.example.demo.model.response.ResponseQuestion;
import com.example.demo.model.response.ResponseSaveManyQuestion;
import com.example.demo.repository.QuestionRepository;
import com.example.demo.service.IQuestionService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;

@Service
public class QuestionServiceImpl implements IQuestionService {
    @Autowired
    private QuestionRepository questionRepository;
    @Autowired
    QuizController quizController;
    @Autowired
    AnswerServiceImpl answerService;
    private ModelMapper modelMapper=new ModelMapper();
    @Value("${sse.server}")
    private String SSE_SERVER;

    public QuestionServiceImpl(QuestionRepository questionRepository) {
        this.questionRepository = questionRepository;
    }

    @Override
    public List<QuestionDTO> getAllQuestion() {
        List<Question> questionList = questionRepository.findAll();
        List<QuestionDTO>questionDTOList=new ArrayList<>();
        for(Question tmp: questionList){
            QuestionDTO questionDTO = modelMapper.map(tmp, QuestionDTO.class);
            questionDTOList.add(questionDTO);
        }
        return questionDTOList;
    }

    @Override
    public Question saveQuestion(QuestionRequest newQuestion) {
        Question question;
        if (newQuestion.getId() != null && questionRepository.existsById(newQuestion.getId())) {
            question = questionRepository.findById(newQuestion.getId()).get();
            newQuestion.setAnswers(question.getAnswers());
            modelMapper.map(newQuestion, question);
        } else {
            question = modelMapper.map(newQuestion, Question.class);
            question.getAnswers().forEach(answer -> answer.setQuestion(question));
        }
        return questionRepository.save(question);
    }

    @Override
    public Question updateQuestion(QuestionRequestCreateManyByFile newQuestion) {
        Question question = questionRepository.findById(newQuestion.getId()).orElseThrow(IllegalArgumentException::new);
        question.setQuestion(newQuestion.getQuestion());
        question.setType(newQuestion.getType());
        question.setTime(newQuestion.getTime());

        return questionRepository.save(question);
    }

    @Override
    public QuestionDTO getQuestionById(int questionId) {
        Question question = questionRepository.findById(questionId).get();
        QuestionDTO questionDTO = modelMapper.map(question, QuestionDTO.class);
        return questionDTO;
    }

    @Override
    public ResponseGetManyQuestion getQuestionByQuiz(int quizId) {
        List<Question> questionList = questionRepository.findByQuizId(quizId);
        List<ResponseQuestion>responseQuestions=new ArrayList<>();
        for(Question tmp: questionList){
            ResponseQuestion responseQuestion = modelMapper.map(tmp, ResponseQuestion.class);
            responseQuestions.add(responseQuestion);
        }
        ResponseGetManyQuestion responseSaveManyQuestion = new ResponseGetManyQuestion();
//        convert response to QuizDTO
        QuizDTO quizDTO = quizController.getQuizByIdInternal(quizId);
        responseSaveManyQuestion.setQuizName(quizDTO.getName());
        responseSaveManyQuestion.setQuestions(responseQuestions);

        return responseSaveManyQuestion;
    }

    @Override
    public ResponseSaveManyQuestion saveManyQuestionByFile(QuestionRequestCreateMany questionRequestList) {
        ResponseEntity<Quiz> response = quizController.saveQuizMany(new QuizRequestCreateByFile(questionRequestList.getQuiz().getName()));
        int quizId = response.getBody().getId();

        if (response.getStatusCode() != HttpStatus.OK) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid quiz name");
        }
        List<Question> questionList = new ArrayList<>();
        for(QuestionRequestCreateManyByFile tmp: questionRequestList.getListQuestion()){
            Question question = modelMapper.map(tmp, Question.class);
            question.getAnswers().forEach(answer -> answer.setQuestion(question));
            question.setQuizId(quizId);
            questionList.add(question);
        }
        List<Question> listQuestionSaveMany  = questionRepository.saveAll(questionList);

        List<ResponseQuestion> responseQuestions = new ArrayList<>();
        for(Question tmp: questionList){
            ResponseQuestion responseQuestion = modelMapper.map(tmp, ResponseQuestion.class);
            responseQuestions.add(responseQuestion);
        }

        ResponseSaveManyQuestion responseSaveManyQuestion = new ResponseSaveManyQuestion();
        responseSaveManyQuestion.setQuizzName(questionRequestList.getQuiz().getName());
        responseSaveManyQuestion.setQuestions(responseQuestions);
        return responseSaveManyQuestion;
    }
    @Override
    public ResponseSaveManyQuestion saveManyQuestion(QuestionQuizRequestCreateMany questionRequestList) {
        RestTemplate restTemplate = new RestTemplate();
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        restTemplate.getForObject("http://" +SSE_SERVER+":8083/send-message?message=Service quiz is running", String.class);
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        QuizRequest questionRequest=questionRequestList.getQuiz();
        ResponseEntity<Quiz> response = quizController.saveQuizManyInternal(questionRequest);
        int quizId = response.getBody().getId();

        if (response.getStatusCode() != HttpStatus.OK) {
            restTemplate.getForObject("http://" +SSE_SERVER+":8083/send-message?message=Error creating quiz", String.class);
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid quiz name");
        }

        restTemplate.getForObject("http://" +SSE_SERVER+":8083/send-message?message=Service quiz runs successfully", String.class);

        //delay 1000ms


        List<Question> questionList = new ArrayList<>();
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        restTemplate.getForObject("http://" +SSE_SERVER+":8083/send-message?message=Service question is running", String.class);
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        for(QuestionRequestCreateManyByFile tmp: questionRequestList.getListQuestion()){
            Question question = modelMapper.map(tmp, Question.class);
            question.getAnswers().forEach(answer -> answer.setQuestion(question));
            question.setQuizId(quizId);
            questionList.add(question);
        }
        questionRepository.saveAll(questionList);

        List<ResponseQuestion> responseQuestions = new ArrayList<>();
        for(Question tmp: questionList){
            ResponseQuestion responseQuestion = modelMapper.map(tmp, ResponseQuestion.class);
            responseQuestions.add(responseQuestion);
        }

        ResponseSaveManyQuestion responseSaveManyQuestion = new ResponseSaveManyQuestion();
        responseSaveManyQuestion.setQuizzName(questionRequestList.getQuiz().getName());
        responseSaveManyQuestion.setQuestions(responseQuestions);
        return responseSaveManyQuestion;
    }
}
