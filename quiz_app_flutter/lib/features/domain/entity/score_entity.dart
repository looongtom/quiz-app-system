import 'package:quiz_app_flutter/features/data/model/score_model/score_model.dart';

class ScoreEntity {
  final int id;
  final double score;
  final DateTime timeStamp;
  final int quizId;
  final int userId;
  final String username;
  final String quizName;

  const ScoreEntity({
    required this.id,
    required this.score,
    required this.timeStamp,
    required this.quizId,
    required this.userId,
    required this.username,
    required this.quizName,
  });

  factory ScoreEntity.fromModel(ScoreModel model) {
    return ScoreEntity(
      id: model.id ?? 0,
      score: model.score ?? 0,
      timeStamp: model.timeStamp ?? DateTime.now(),
      quizId: model.quizId ?? 0,
      userId: model.userId ?? 0,
      username: model.username ?? '',
      quizName: model.quizName ?? '',
    );
  }

  ScoreEntity copyWith({
    int? id,
    double? score,
    DateTime? timeStamp,
    int? quizId,
    int? userId,
    String? username,
    String? quizName,
  }) {
    return ScoreEntity(
      id: id ?? this.id,
      score: score ?? this.score,
      timeStamp: timeStamp ?? this.timeStamp,
      quizId: quizId ?? this.quizId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      quizName: quizName ?? this.quizName,
    );
  }
}