package com.example.demo.repository;

import com.example.demo.entity.Score;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ScoreRepository extends JpaRepository<Score,Integer> {
    List<Score> findByQuizIdOrderByTimestampDesc(int quizId);
    List<Score> findByUserIdOrderByTimestampDesc(int userId);

    Page<Score> findByQuizIdOrderByTimestampDesc( Pageable pageable,int quizId);
    Page<Score> findByUserIdOrderByTimestampDesc( Pageable pageable,int userId);
}
