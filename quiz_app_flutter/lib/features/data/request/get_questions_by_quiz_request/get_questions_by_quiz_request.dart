import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_questions_by_quiz_request.freezed.dart';

part 'get_questions_by_quiz_request.g.dart';

@freezed
class GetQuestionsByQuizRequest with _$GetQuestionsByQuizRequest {
  const factory GetQuestionsByQuizRequest({
    required int quizId,
  }) = _GetQuestionsByQuizRequest;

  factory GetQuestionsByQuizRequest.fromJson(Map<String, dynamic> json) =>
      _$GetQuestionsByQuizRequestFromJson(json);
}
