package com.example.demo.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@ToString
@RequiredArgsConstructor
@Table(name = "quizzes")
public class Quiz {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;
    @Column(name = "name", nullable = false)
    private String name;
    @Column(name="startAt", nullable = true)
    private LocalDateTime startAt;
    @Column(name="expireAt", nullable = true)
    private LocalDateTime expireAt;
    @Enumerated(EnumType.ORDINAL)
    @Column(name = "privacy", nullable = true)
    private PrivacyQuizType privacy;
}
