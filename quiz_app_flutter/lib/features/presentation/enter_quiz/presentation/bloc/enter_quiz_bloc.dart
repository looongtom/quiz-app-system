import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:quiz_app_flutter/base/bloc/base_bloc.dart';
import 'package:quiz_app_flutter/base/bloc/base_bloc_state.dart';
import 'package:quiz_app_flutter/base/bloc/bloc_status.dart';
import 'package:quiz_app_flutter/base/network/errors/extension.dart';
import 'package:quiz_app_flutter/features/data/request/get_questions_by_quiz_request/get_questions_by_quiz_request.dart';
import 'package:quiz_app_flutter/features/domain/entity/quiz_entity.dart';
import 'package:quiz_app_flutter/features/domain/repository/quiz_repository.dart';

part 'enter_quiz_event.dart';

part 'enter_quiz_state.dart';

part 'enter_quiz_bloc.freezed.dart';

part 'enter_quiz_bloc.g.dart';

@injectable
class EnterQuizBloc extends BaseBloc<EnterQuizEvent, EnterQuizState> {
  EnterQuizBloc(this._repository) : super(EnterQuizState.init()) {
    on<EnterQuizEvent>((event, emit) async {
      await event.when(
        detectQRLink: (link) => detectQRLink(emit, link),
        inputQuizId: (quizId) => inputQuizId(emit, quizId),
        onEnterQuiz: () => onEnterQuiz(emit),
      );
    });
  }

  final QuizRepository _repository;

  detectQRLink(Emitter<EnterQuizState> emit, String link) {
    emit(
      state.copyWith(
        status: BaseStateStatus.idle,
        linkQuiz: link,
      ),
    );
  }

  inputQuizId(Emitter<EnterQuizState> emit, String quizId) {
    emit(
      state.copyWith(
        status: BaseStateStatus.idle,
        quizId: quizId,
      ),
    );
  }

  Future<void> onEnterQuiz(Emitter<EnterQuizState> emit) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
      ),
    );
    final res = await _repository.getQuestionsByQuiz(
      request: GetQuestionsByQuizRequest(
        quizId: int.tryParse(state.quizId ?? '0') ?? 0,
      ),
    );
    res.fold(
      (l) => emit(
        state.copyWith(
          status: BaseStateStatus.failed,
          message: l.getError,
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            status: BaseStateStatus.success,
            quiz: r,
          ),
        );

        // refresh state
        emit(
          state.copyWith(
            status: BaseStateStatus.idle,
          ),
        );
      },
    );
  }
}
