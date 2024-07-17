package com.example.authorizequiz.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Getter
@Setter
@ToString
@RequiredArgsConstructor
@Table(name = "permissions_quiz")
public class PermissionQuiz {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",nullable = false)
    private int id;

    @Column(name = "quiz_id", nullable = false)
    private int quizId;

    @Column(name = "user_id", nullable = false)
    private int userId;
}
