import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quiz_app_flutter/features/data/model/question_model/question_model.dart';

part 'get_questions_by_quiz_response.freezed.dart';

part 'get_questions_by_quiz_response.g.dart';

@freezed
class GetQuestionsByQuizResponse with _$GetQuestionsByQuizResponse {
  const factory GetQuestionsByQuizResponse({
    String? quizzName,
    List<QuestionModel>? questions,
  }) = _GetQuestionsByQuizResponse;

  factory GetQuestionsByQuizResponse.fromJson(Map<String, dynamic> json) =>
      _$GetQuestionsByQuizResponseFromJson(json);
}
