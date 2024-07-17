package com.example.demo.controller;

import com.example.demo.util.FileService;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
@CrossOrigin(maxAge = 3600)
@RequestMapping("/api/v1/file")
@RestController
public class ReadFileController {
    private final FileService fileService;

    public ReadFileController(FileService fileService) {
        this.fileService = fileService;
    }

    @PostMapping("/upload")
    public Object upload(
            @RequestParam MultipartFile file,
            @RequestParam Integer numberOfSheet,
            @RequestParam String quizName)
            throws Exception {


        return fileService.upload(file, numberOfSheet, quizName);

    }
    @PostMapping("/upload-preview")
    public Object uploadPreview(
            @RequestParam MultipartFile file,
            @RequestParam Integer numberOfSheet)
            throws Exception {


        return fileService.uploadPreview(file, numberOfSheet);

    }
}
