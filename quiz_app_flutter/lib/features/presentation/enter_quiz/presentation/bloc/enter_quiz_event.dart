part of 'enter_quiz_bloc.dart';

@freezed
class EnterQuizEvent with _$EnterQuizEvent {
  const factory EnterQuizEvent.detectQRLink({
    required String link,
  }) = _DetectQRLink;

  const factory EnterQuizEvent.inputQuizId({
    required String quizId,
  }) = _InputQuizId;

  const factory EnterQuizEvent.onEnterQuiz() = _OnEnterQuiz;
}
