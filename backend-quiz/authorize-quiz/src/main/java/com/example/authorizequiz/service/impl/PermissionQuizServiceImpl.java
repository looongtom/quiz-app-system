package com.example.authorizequiz.service.impl;

import com.example.authorizequiz.entity.PermissionQuiz;
import com.example.authorizequiz.model.dto.PermissionQuizDTO;
import com.example.authorizequiz.repository.PermissionQuizRepository;
import com.example.authorizequiz.service.IPermissionQuizService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class PermissionQuizServiceImpl implements IPermissionQuizService {
    @Autowired
    private PermissionQuizRepository permissionQuizRepository;

    private ModelMapper modelMapper = new ModelMapper();

    public PermissionQuizServiceImpl(PermissionQuizRepository permissionQuizRepository) {
        this.permissionQuizRepository = permissionQuizRepository;
    }

    @Override
    public List<PermissionQuiz> addPermissionForQuiz(PermissionQuizDTO permissionQuizDTO) {
        int quizId=permissionQuizDTO.getQuizId();
        List<Integer> listUserId = permissionQuizDTO.getListUserId();
        List<PermissionQuiz>listPermissionQuiz = new ArrayList<>();
        for (Integer useId:
             listUserId) {
            PermissionQuiz permissionQuiz = new PermissionQuiz();
            permissionQuiz.setQuizId(quizId);
            permissionQuiz.setUserId(useId);

            listPermissionQuiz.add(permissionQuiz);
        }
        return permissionQuizRepository.saveAll(listPermissionQuiz);
    }

    @Override
    public Boolean checkPermission(int userId, int quizId) {
        return permissionQuizRepository.existsByQuizIdAndUserId(quizId, userId);
    }

    @Override
    public Boolean deletePermission(int userId, int quizId) {
        return permissionQuizRepository.deleteByUserIdAndQuizId(userId,quizId) > 0;
    }
}
