package com.example.demo.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import lombok.*;


@Entity
@Getter
@Setter
@ToString
@RequiredArgsConstructor
@Table(name = "answers")
public class Answer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(name = "name", nullable = false)
    private String name;
    @ManyToOne(optional = false, fetch = FetchType.LAZY, cascade =CascadeType.ALL)
    @JsonBackReference
    private Question question;

    @Column(name = "is_correct", nullable = false)
    @JsonProperty("isCorrect")
    private boolean isCorrect = false;

    public Answer(String name, Question question) {
        this.name = name;
        this.question = question;
    }

}
