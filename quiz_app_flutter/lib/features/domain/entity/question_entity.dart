import 'package:quiz_app_flutter/features/data/model/question_model/question_model.dart';
import 'package:quiz_app_flutter/features/domain/entity/answer_entity.dart';
import 'package:quiz_app_flutter/features/domain/enum/question_type.dart';

class QuestionEntity {
  final String question;
  final QuestionType type;
  final double time;
  final List<AnswerEntity> answers;

  const QuestionEntity({
    required this.question,
    required this.type,
    required this.time,
    required this.answers,
  });

  factory QuestionEntity.fromModel(QuestionModel model) {
    return QuestionEntity(
      question: model.question ?? '',
      type: model.type ?? QuestionType.singleChoice,
      time: model.time ?? 0,
      answers: (model.answers ?? [])
          .map((e) => AnswerEntity.fromModel(e))
          .toList(),
    );
  }
}
