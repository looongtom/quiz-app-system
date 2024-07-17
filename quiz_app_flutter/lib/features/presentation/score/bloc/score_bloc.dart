import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:quiz_app_flutter/base/bloc/base_bloc.dart';
import 'package:quiz_app_flutter/base/bloc/base_bloc_state.dart';
import 'package:quiz_app_flutter/base/bloc/bloc_status.dart';
import 'package:quiz_app_flutter/base/network/errors/extension.dart';
import 'package:quiz_app_flutter/features/data/request/insert_score_request/insert_score_request.dart';
import 'package:quiz_app_flutter/features/domain/entity/score_entity.dart';
import 'package:quiz_app_flutter/features/domain/repository/auth_repository.dart';
import 'package:quiz_app_flutter/features/domain/repository/score_repository.dart';

part 'score_event.dart';

part 'score_state.dart';

part 'score_bloc.freezed.dart';

part 'score_bloc.g.dart';

@injectable
class ScoreBloc extends BaseBloc<ScoreEvent, ScoreState> {
  ScoreBloc(this._authRepository, this._scoreRepository)
      : super(ScoreState.init()) {
    on<ScoreEvent>((event, emit) async {
      await event.when(
        init: (score, quizId, isDoQuizHistory) => init(
          emit,
          score,
          quizId,
          isDoQuizHistory,
        ),
        insertScore: () => insertScore(emit),
        getLeaderboard: () => getLeaderboard(emit),
        getDoQuizHistory: () => getDoQuizHistory(emit),
      );
    });
  }

  final AuthRepository _authRepository;
  final ScoreRepository _scoreRepository;

  Future<void> init(
    Emitter<ScoreState> emit,
    double score,
    int quizId,
    bool isDoQuizHistory,
  ) async {
    emit(state.copyWith(status: BaseStateStatus.loading));
    final result = await _authRepository.getUserInfo();
    await result.fold(
      (l) async {
        emit(
          state.copyWith(
            status: BaseStateStatus.failed,
            message: l.getError,
          ),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            userId: r.id,
            score: score,
            quizId: quizId,
            username: r.username,
          ),
        );
        add(const ScoreEvent.insertScore());
      },
    );
  }

  Future<void> insertScore(
    Emitter<ScoreState> emit,
  ) async {
    emit(state.copyWith(status: BaseStateStatus.loading));
    final result = await _scoreRepository.insertScore(
      request: InsertScoreRequest(
        score: state.score,
        quizId: state.quizId,
        username: state.username,
        userId: state.userId,
      ),
    );
    await result.fold(
      (l) async {
        emit(
          state.copyWith(
            status: BaseStateStatus.failed,
            message: l.getError,
          ),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            score: state.score,
          ),
        );
        add(const ScoreEvent.getLeaderboard());
      },
    );
  }

  Future<void> getLeaderboard(Emitter<ScoreState> emit) async {
    emit(state.copyWith(status: BaseStateStatus.loading));
    final result = await _scoreRepository.getScoreByQuiz(quizId: state.quizId);
    result.fold(
      (l) => emit(
        state.copyWith(
          status: BaseStateStatus.failed,
          message: l.getError,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: BaseStateStatus.success,
          leaderboard: r,
        ),
      ),
    );
  }

  Future<void> getDoQuizHistory(Emitter<ScoreState> emit) async {
    emit(state.copyWith(status: BaseStateStatus.loading));
    final result = await _authRepository.getUserInfo();
    await result.fold(
      (l) async {
        emit(
          state.copyWith(
            status: BaseStateStatus.failed,
            message: l.getError,
          ),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            userId: r.id,
            username: r.username,
          ),
        );
        final getScoresByUser = await _scoreRepository.getScoreByUser(
          userId: state.userId,
        );
        getScoresByUser.fold(
          (l) => emit(
            state.copyWith(
              status: BaseStateStatus.failed,
              message: l.getError,
            ),
          ),
          (r) => emit(
            state.copyWith(
              status: BaseStateStatus.success,
              leaderboard: r,
            ),
          ),
        );
      },
    );
  }
}
