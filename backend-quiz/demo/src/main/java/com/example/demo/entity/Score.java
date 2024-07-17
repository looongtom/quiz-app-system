package com.example.demo.entity;


import com.fasterxml.jackson.annotation.JsonBackReference;
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
@Table(name = "scores")
public class Score {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",nullable = false)
    private int id;
    @Column(name = "score", nullable = false)
    private double score;

    @Column(name = "createdAt", nullable = false)
    private LocalDateTime timestamp = LocalDateTime.now();

    @Column(name = "userId", nullable = false)
    private int userId;

    @Column(name = "username", nullable = false)
    private String username;

    @ManyToOne(optional = false, fetch = FetchType.LAZY, cascade =CascadeType.ALL)
    @JsonBackReference
    private Quiz quiz;
}
