import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:quiz_app_flutter/base/bloc/base_bloc.dart';
import 'package:quiz_app_flutter/base/bloc/base_bloc_state.dart';
import 'package:quiz_app_flutter/base/bloc/bloc_status.dart';
import 'package:quiz_app_flutter/base/network/errors/extension.dart';
import 'package:quiz_app_flutter/common/constants/auth_constants.dart';
import 'package:quiz_app_flutter/common/extensions/string_extension.dart';
import 'package:quiz_app_flutter/common/local_data/secure_storage.dart';
import 'package:quiz_app_flutter/di/di_setup.dart';
import 'package:quiz_app_flutter/features/data/request/login_request/login_request.dart';
import 'package:quiz_app_flutter/features/domain/repository/auth_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

part 'login_bloc.freezed.dart';

part 'login_bloc.g.dart';

@injectable
class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  LoginBloc(this._repository) : super(LoginState.init()) {
    on<LoginEvent>((event, emit) async {
      await event.when(
        onInputUsername: (username) => onInputUsername(emit, username),
        onInputPassword: (password) => onInputPassword(emit, password),
        onPasswordVisibilityChanged: (isVisible) =>
            onPasswordVisibilityChanged(emit, isVisible),
        login: () => login(emit),
      );
    });
  }

  final AuthRepository _repository;

  Future<void> onInputUsername(
      Emitter<LoginState> emit, String username) async {
    emit(
      state.copyWith(
        username: username,
        status: BaseStateStatus.idle,
        actionState: LoginActionState.idle,
      ),
    );
  }

  Future<void> onInputPassword(
      Emitter<LoginState> emit, String password) async {
    emit(
      state.copyWith(
        password: password,
        status: BaseStateStatus.idle,
        actionState: LoginActionState.idle,
      ),
    );
  }

  Future<void> onPasswordVisibilityChanged(
      Emitter<LoginState> emit, bool isVisible) async {
    emit(
      state.copyWith(
        isPasswordVisible: isVisible,
        status: BaseStateStatus.idle,
        actionState: LoginActionState.idle,
      ),
    );
  }

  Future<void> login(Emitter<LoginState> emit) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
        actionState: LoginActionState.idle,
      ),
    );

    final res = await _repository.signInWithEmailAndPassword(
      request: LoginRequest(
        username: state.username,
        password: state.password,
      ),
    );

    await res.fold((l) async {
      emit(
        state.copyWith(
          status: BaseStateStatus.failed,
          actionState: LoginActionState.loginError,
          message: l.getError,
        ),
      );
    }, (r) async {
      await getIt<SecureStorage>().save(AuthConstants.token, r.token);
      emit(
        state.copyWith(
          status: BaseStateStatus.success,
          actionState: LoginActionState.loginSuccess,
        ),
      );
    });
  }
}
