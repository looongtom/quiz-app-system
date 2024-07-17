import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_model.freezed.dart';
part 'score_model.g.dart';

@freezed
class ScoreModel with _$ScoreModel {
  const factory ScoreModel({
    int? id,
    double? score,
    DateTime? timeStamp,
    int? quizId,
    int? userId,
    String? username,
    String? quizName,
  }) = _ScoreModel;

  factory ScoreModel.fromJson(Map<String, dynamic> json) =>
      _$ScoreModelFromJson(json);
}
