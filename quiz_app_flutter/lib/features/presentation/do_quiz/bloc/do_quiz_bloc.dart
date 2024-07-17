import 'dart:async';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:quiz_app_flutter/base/bloc/base_bloc.dart';
import 'package:quiz_app_flutter/base/bloc/base_bloc_state.dart';
import 'package:quiz_app_flutter/base/bloc/bloc_status.dart';
import 'package:quiz_app_flutter/common/constants/other_constants.dart';
import 'package:quiz_app_flutter/features/domain/entity/answer_entity.dart';
import 'package:quiz_app_flutter/features/domain/entity/quiz_entity.dart';

part 'do_quiz_event.dart';

part 'do_quiz_state.dart';

part 'do_quiz_bloc.freezed.dart';

part 'do_quiz_bloc.g.dart';

@injectable
class DoQuizBloc extends BaseBloc<DoQuizEvent, DoQuizState> {
  DoQuizBloc() : super(DoQuizState.init()) {
    on<DoQuizEvent>((event, emit) async {
      await event.when(
        init: (quiz) => init(emit, quiz),
        onSelectAnswer: (isRightAnswer) => onSelectAnswer(emit, isRightAnswer),
        nextQuestion: () => nextQuestion(emit),
        onSelectMultipleChoiceQuestionAnswer: (answer, isSelected) =>
            onSelectMultipleChoiceQuestionAnswer(
          emit,
          answer,
          isSelected,
        ),
        onSubmitMultipleChoiceQuestionAnswer: () =>
            onSubmitMultipleChoiceQuestionAnswer(),
        finish: () => finish(emit),
      );
    });
  }

  Future<void> init(
    Emitter<DoQuizState> emit,
    QuizEntity quiz,
  ) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.init,
        quiz: quiz,
        currentQuestionIndex: 1,
        time: quiz.questions[0].time,
      ),
    );

    /// countdown
    do {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(time: state.time - 1));
      if (state.isShowAnswers) {
        break;
      }
    } while (state.time > 0);

    /// if didn't select answer => wrong answer + 1
    if (!state.isShowAnswers) {
      add(const DoQuizEvent.onSelectAnswer(isRightAnswer: false));
    }
  }

  Future<void> onSelectAnswer(
      Emitter<DoQuizState> emit, bool isRightAnswer) async {
    emit(
      state.copyWith(
        isShowAnswers: true,
        numberOfRightAnswers: isRightAnswer
            ? state.numberOfRightAnswers + 1
            : state.numberOfRightAnswers,
        numberOfWrongAnswers: !isRightAnswer
            ? state.numberOfWrongAnswers + 1
            : state.numberOfWrongAnswers,
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    emit(
      state.copyWith(
        isShowAnswers: false,
        selectedMultipleQuestionAnswers: [],
      ),
    );
    if(state.currentQuestionIndex == state.quiz?.questions.length) {
      add(const DoQuizEvent.finish());
    } else {
      add(const DoQuizEvent.nextQuestion());
    }
  }

  Future<void> onSelectMultipleChoiceQuestionAnswer(
      Emitter<DoQuizState> emit, AnswerEntity answer, bool isSelected) async {
    List<AnswerEntity> selectedAnswers =
        state.selectedMultipleQuestionAnswers.toList();
    if (isSelected) {
      selectedAnswers.add(answer);
    } else {
      selectedAnswers.remove(answer);
    }
    emit(
      state.copyWith(selectedMultipleQuestionAnswers: selectedAnswers),
    );
  }

  Future<void> onSubmitMultipleChoiceQuestionAnswer() async {
    final rightAnswers = state
        .quiz?.questions[state.currentQuestionIndex - 1].answers
        .where((element) => element.isCorrect)
        .toList();
    add(
      DoQuizEvent.onSelectAnswer(
        isRightAnswer:
            listEquals(rightAnswers, state.selectedMultipleQuestionAnswers),
      ),
    );
  }

  Future<void> nextQuestion(Emitter<DoQuizState> emit) async {
    final newQuestionIndex = state.currentQuestionIndex + 1;
    emit(
      state.copyWith(
        status: BaseStateStatus.idle,
        currentQuestionIndex: newQuestionIndex,
        time: state.quiz?.questions[newQuestionIndex - 1].time,
      ),
    );
    do {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(time: state.time - 1));
      if (state.isShowAnswers) {
        break;
      }
    } while (state.time > 0);

    /// if didn't select answer => wrong answer + 1
    if (!state.isShowAnswers) {
      add(const DoQuizEvent.onSelectAnswer(isRightAnswer: false));
    }
  }

  Future<void> finish(Emitter<DoQuizState> emit) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.success,
      ),
    );
  }
}
