part of 'do_quiz_bloc.dart';

@freezed
class DoQuizEvent with _$DoQuizEvent {
  const factory DoQuizEvent.init({
    required QuizEntity quiz,
  }) = _DoQuizInit;

  const factory DoQuizEvent.onSelectAnswer({
    required bool isRightAnswer,
  }) = _DoQuizSelectAnswer;

  const factory DoQuizEvent.onSelectMultipleChoiceQuestionAnswer({
    required AnswerEntity answer,
    required bool isSelected,
  }) = _DoQuizSelectMultipleChoiceQuestionAnswer;

  const factory DoQuizEvent.onSubmitMultipleChoiceQuestionAnswer() =
      _DoQuizSubmitMultipleChoiceQuestionAnswer;

  const factory DoQuizEvent.nextQuestion() = _DoQuizNextQuestion;

  const factory DoQuizEvent.finish() = _DoQuizFinish;
}
