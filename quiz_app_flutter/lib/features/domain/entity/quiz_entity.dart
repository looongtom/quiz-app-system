import 'package:quiz_app_flutter/features/data/response/get_questions_by_quiz_response/get_questions_by_quiz_response.dart';
import 'package:quiz_app_flutter/features/domain/entity/question_entity.dart';

class QuizEntity {
  final String quizName;
  final List<QuestionEntity> questions;

  QuizEntity({
    required this.quizName,
    required this.questions,
  });

  factory QuizEntity.fromModel(GetQuestionsByQuizResponse model) {
    return QuizEntity(
      quizName: model.quizzName ?? '',
      questions: (model.questions ?? [])
          .map((e) => QuestionEntity.fromModel(e))
          .toList(),
    );
  }
}