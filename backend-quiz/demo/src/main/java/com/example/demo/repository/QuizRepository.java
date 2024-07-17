package com.example.demo.repository;

import com.example.demo.entity.Quiz;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface QuizRepository extends JpaRepository<Quiz, Integer> {
    Quiz findQuizById(int id);

    Page<Quiz> findAll(Pageable pageable);
    Page<Quiz> findQuizByNameContainingIgnoreCase(Pageable pageable, String quizName);
}