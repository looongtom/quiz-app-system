part of 'enter_quiz_bloc.dart';

@CopyWith()
class EnterQuizState extends BaseBlocState {
  final String? linkQuiz;
  final String? quizId;
  final QuizEntity? quiz;

  const EnterQuizState({
    required super.status,
    super.message,
    this.linkQuiz,
    this.quizId,
    this.quiz,
  });

  factory EnterQuizState.init() => const EnterQuizState(
        status: BaseStateStatus.init,
      );

  @override
  List get props => [
    status,
    message,
    linkQuiz,
    quizId,
    quiz,
  ];
}
