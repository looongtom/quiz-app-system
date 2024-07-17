part of 'score_bloc.dart';

@freezed
class ScoreEvent with _$ScoreEvent {
  const factory ScoreEvent.init({
    required double score,
    required int quizId,
    required bool isDoQuizHistory,
  }) = _ScoreInit;

  const factory ScoreEvent.insertScore() = _ScoreInsert;

  const factory ScoreEvent.getLeaderboard() = _ScoreGetLeaderboard;

  const factory ScoreEvent.getDoQuizHistory() = _ScoreGetDoQuizHistory;
}
