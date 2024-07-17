import 'package:dartz/dartz.dart';
import 'package:quiz_app_flutter/base/network/errors/error.dart';
import 'package:quiz_app_flutter/features/data/request/get_questions_by_quiz_request/get_questions_by_quiz_request.dart';
import 'package:quiz_app_flutter/features/domain/entity/quiz_entity.dart';

abstract class QuizRepository {
  Future<Either<BaseError, QuizEntity>> getQuestionsByQuiz({
    required GetQuestionsByQuizRequest request,
  });
}