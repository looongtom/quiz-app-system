package com.example.demo.service;

import com.example.demo.entity.Question;
import com.example.demo.model.dto.QuestionDTO;
import com.example.demo.model.request.QuestionQuizRequestCreateMany;
import com.example.demo.model.request.QuestionRequest;
import com.example.demo.model.request.QuestionRequestCreateMany;
import com.example.demo.model.request.QuestionRequestCreateManyByFile;
import com.example.demo.model.response.ResponseGetManyQuestion;
import com.example.demo.model.response.ResponseSaveManyQuestion;

import java.util.List;

public interface IQuestionService {
    List<QuestionDTO>getAllQuestion();
    Question saveQuestion(QuestionRequest newQuestion);
    Question updateQuestion(QuestionRequestCreateManyByFile newQuestion);
    QuestionDTO getQuestionById(int questionId);
    ResponseGetManyQuestion getQuestionByQuiz(int quizId);
    ResponseSaveManyQuestion saveManyQuestion(QuestionQuizRequestCreateMany questionRequestList);
    ResponseSaveManyQuestion saveManyQuestionByFile(QuestionRequestCreateMany questionRequestList);
}
