import 'package:freezed_annotation/freezed_annotation.dart';

part 'insert_score_request.freezed.dart';
part 'insert_score_request.g.dart';

@freezed
class InsertScoreRequest with _$InsertScoreRequest {
  const factory InsertScoreRequest({
    required double score,
    required int quizId,
    required int userId,
    required String username,
  }) = _InsertScoreRequest;

  factory InsertScoreRequest.fromJson(Map<String, dynamic> json) =>
      _$InsertScoreRequestFromJson(json);
}