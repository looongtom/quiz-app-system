package com.example.demo.repository;

import com.example.demo.entity.Question;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface QuestionRepository extends JpaRepository<Question, Integer> {
    public List<Question> findByQuizId(int quizId);
}