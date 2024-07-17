part of 'do_quiz_bloc.dart';

@CopyWith()
class DoQuizState extends BaseBlocState {
  final QuizEntity? quiz;
  final double time;
  final int currentQuestionIndex;
  final int numberOfRightAnswers;
  final int numberOfWrongAnswers;
  final bool isShowAnswers;
  final List<AnswerEntity> selectedMultipleQuestionAnswers;

  const DoQuizState({
    this.quiz,
    required this.currentQuestionIndex,
    required this.time,
    required super.status,
    super.message,
    required this.numberOfRightAnswers,
    required this.numberOfWrongAnswers,
    required this.isShowAnswers,
    this.selectedMultipleQuestionAnswers = const [],
  });

  factory DoQuizState.init() => const DoQuizState(
        status: BaseStateStatus.init,
        time: QuizConstants.defaultTime,
        currentQuestionIndex: -1,
        numberOfRightAnswers: 0,
        numberOfWrongAnswers: 0,
        isShowAnswers: false,
        selectedMultipleQuestionAnswers: [],
      );

  @override
  List get props => [
        status,
        message,
        quiz,
        time,
        currentQuestionIndex,
        numberOfRightAnswers,
        numberOfWrongAnswers,
        isShowAnswers,
        selectedMultipleQuestionAnswers,
      ];
}
