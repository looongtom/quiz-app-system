package com.example.authorizequiz.repository;

import com.example.authorizequiz.entity.PermissionQuiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

public interface PermissionQuizRepository extends JpaRepository<PermissionQuiz, Integer> {
    @Transactional
    @Modifying
    @Query("delete from PermissionQuiz p where p.userId = ?1 and p.quizId = ?2")
    int deleteByUserIdAndQuizId(int userId, int quizId);
    boolean existsByQuizIdAndUserId(int quizId, int userId);
}