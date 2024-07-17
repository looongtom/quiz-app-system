import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quiz_app_flutter/features/data/model/answer_model/answer_model.dart';
import 'package:quiz_app_flutter/features/domain/enum/question_type.dart';

part 'question_model.freezed.dart';
part 'question_model.g.dart';

@freezed
class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    String? question,
    QuestionType? type,
    double? time,
    List<AnswerModel>? answers,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
}
