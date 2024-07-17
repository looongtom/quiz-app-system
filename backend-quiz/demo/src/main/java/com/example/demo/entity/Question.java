package com.example.demo.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.Hibernate;

import java.util.ArrayList;
import java.util.List;


@Entity
@Getter
@Setter
@ToString
@RequiredArgsConstructor
@Table(name = "questions")
public class Question {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;
    @Column(name = "question", nullable = false)
    private String question;
    @Column(name = "quizz_id", nullable = false)
    private int quizId;
    @Enumerated(EnumType.STRING)
    @Column(name = "type")
    private QuestionType type;
    @Column(name = "time")
    private double time;

    @OneToMany(mappedBy = "question", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference
    private List<Answer> answers=new ArrayList<>();

}
