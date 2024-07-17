package com.example.demo.controller;


import com.example.demo.model.PermissionQuizDTO;
import com.example.demo.entity.PrivacyQuizType;
import com.example.demo.entity.Quiz;
import com.example.demo.model.dto.QuizDTO;
import com.example.demo.model.request.QuizRequest;
import com.example.demo.model.request.QuizRequestCreateByFile;
import com.example.demo.model.response.PaginationResponse;
import com.example.demo.model.response.ResponseHandler;
import com.example.demo.service.IQuizService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.List;

@CrossOrigin(maxAge = 3600)
@RequestMapping("/api/v1/quiz")
@RestController
public class QuizController {
    @Autowired
    private IQuizService iQuizService;

    @Autowired
    private WebClient webClient;
    @Value("${permission.quiz.server}")
    private String PERMISSION_QUIZ_SERVER;
    public QuizController(IQuizService iQuizService) {
        this.iQuizService = iQuizService;
    }

    @GetMapping("/get-all-quiz")
    public ResponseEntity<Object> getAllQuiz() {
        List<QuizDTO> quizDTOList = iQuizService.getAllQuiz();
        return ResponseHandler.generateResponse("Get all quiz successfully", HttpStatus.OK, quizDTOList);
    }

    @PostMapping("/save-quiz")
    public ResponseEntity<Object> saveQuiz(@RequestBody QuizRequest quizRequest) {
//        return ResponseEntity.ok(iQuizService.saveQuiz(quizRequest));
        Quiz quiz = iQuizService.saveQuiz(quizRequest);
        PermissionQuizDTO permissionQuizDTO = new PermissionQuizDTO(quiz.getId(), quizRequest.getListUserId());
        if (quizRequest.getPrivacy() == PrivacyQuizType.PRIVATE) {
            ResponseEntity<Object> responseEntity = callPermissionController(permissionQuizDTO).block();
        }
        return ResponseHandler.generateResponse("Save quiz successfully", HttpStatus.OK, quiz);
    }

    @PostMapping("/call-permission-controller")
    public Mono<ResponseEntity<Object>> callPermissionController(@RequestBody PermissionQuizDTO permissionQuizDTO) {
        return webClient.post()
                .uri("http://" +PERMISSION_QUIZ_SERVER+":8082/api/v1/permission-quiz/add")
                .body(Mono.just(permissionQuizDTO), PermissionQuizDTO.class)
                .retrieve()
                .toEntity(Object.class);
    }


    @PostMapping("/save-quiz-many")
    public ResponseEntity<Quiz> saveQuizMany(@RequestBody QuizRequestCreateByFile quizRequest) {
        return ResponseEntity.ok(iQuizService.saveQuizMany(quizRequest));
    }

    public ResponseEntity<Quiz> saveQuizManyInternal(@RequestBody QuizRequest quizRequest) {
        Quiz quiz = iQuizService.saveQuiz(quizRequest);
        PermissionQuizDTO permissionQuizDTO = new PermissionQuizDTO(quiz.getId(), quizRequest.getListUserId());
        if (quizRequest.getPrivacy() == PrivacyQuizType.PRIVATE) {
            ResponseEntity<Object> responseEntity = callPermissionController(permissionQuizDTO).block();
        }
        return ResponseEntity.ok(quiz);
    }

    @GetMapping("/get-by-id")
    public ResponseEntity<Object> getQuizById(@RequestParam int id) {
        return ResponseHandler.generateResponse("Get quiz by id success", HttpStatus.OK, iQuizService.getQuizById(id));
    }

    public QuizDTO getQuizByIdInternal(@RequestParam int id) {
        return iQuizService.getQuizById(id);
    }

    @GetMapping("/search-quiz")
    public ResponseEntity<Object> searchQuiz(
            @RequestParam(defaultValue = "0") Integer pageNo,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(defaultValue = "") String quizName
    ) {
        Pageable pageable = PageRequest.of(pageNo, pageSize);
        Page<QuizDTO> pageQuiz = iQuizService.searchQuiz(pageable, quizName);

        PaginationResponse paginationResponse = new PaginationResponse();
        paginationResponse.setTotalPage(pageQuiz.getTotalPages());
        paginationResponse.setTotalItem(pageQuiz.getTotalElements());
        paginationResponse.setCurrentPage(pageNo);
        paginationResponse.setItemPerPage(pageSize);
        paginationResponse.setData(pageQuiz.getContent());
        paginationResponse.setSearch(quizName);

        return ResponseHandler.generateResponse("Search quiz success", HttpStatus.OK, paginationResponse);
    }
}
