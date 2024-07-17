import 'package:quiz_app_flutter/base/bloc/index.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:quiz_app_flutter/base/network/errors/extension.dart';
import 'package:quiz_app_flutter/common/constants/auth_constants.dart';
import 'package:quiz_app_flutter/common/local_data/secure_storage.dart';
import 'package:quiz_app_flutter/di/di_setup.dart';
import 'package:quiz_app_flutter/features/domain/repository/auth_repository.dart';

part 'core_bloc.freezed.dart';
part 'core_bloc.g.dart';
part 'core_event.dart';
part 'core_state.dart';

@injectable
class CoreBloc extends BaseBloc<CoreEvent, CoreState> {
  CoreBloc(this._authRepository) : super(CoreState.init()) {
    on<CoreEvent>((CoreEvent event, Emitter<CoreState> emit) async {
      await event.when(
        init: () => init(emit),
        enterQuizWithQR: () => enterQuizWithQR(emit),
        logout: () => onLogout(emit),
      );
    });
  }

  final AuthRepository _authRepository;

  Future<void> init(Emitter<CoreState> emit) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
      ),
    );
    final res = await _authRepository.getUserInfo();
    res.fold(
      (l) => emit(
        state.copyWith(
          status: BaseStateStatus.failed,
          message: l.getError,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: BaseStateStatus.idle,
          username: r.username,
          email: r.email,
        ),
      ),
    );
  }

  enterQuizWithQR(Emitter<CoreState> emit) async {}

  Future<void> onLogout(Emitter<CoreState> emit) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
      ),
    );
    final res = await _authRepository.signOut();
    await res.fold(
      (l) async {
        emit(
          state.copyWith(
            status: BaseStateStatus.failed,
            message: l.getError,
          ),
        );
      },
      (r) async {
        await getIt<SecureStorage>().deleteItem(AuthConstants.token);
        emit(state.copyWith(status: BaseStateStatus.success));
      },
    );
  }
}
