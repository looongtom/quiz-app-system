part of 'score_bloc.dart';

@CopyWith()
class ScoreState extends BaseBlocState {
  final double score;
  final List<ScoreEntity> leaderboard;
  final int userId;
  final String username;
  final int quizId;

  const ScoreState({
    required super.status,
    super.message,
    required this.score,
    required this.leaderboard,
    required this.userId,
    required this.username,
    required this.quizId,
  });

  factory ScoreState.init() {
    return const ScoreState(
      status: BaseStateStatus.init,
      score: 0,
      userId: -1,
      quizId: -1,
      leaderboard: [],
      username: '',
    );
  }

  @override
  List get props => [
        status,
        message,
        score,
        leaderboard,
        userId,
        quizId,
        username,
      ];
}
