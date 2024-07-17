import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:quiz_app_flutter/base/bloc/base_bloc.dart';
import 'package:quiz_app_flutter/base/bloc/base_bloc_state.dart';
import 'package:quiz_app_flutter/base/bloc/bloc_status.dart';
import 'package:quiz_app_flutter/base/network/errors/extension.dart';
import 'package:quiz_app_flutter/common/extensions/string_extension.dart';
import 'package:quiz_app_flutter/features/data/request/register_request/register_request.dart';
import 'package:quiz_app_flutter/features/domain/enum/role_type.dart';
import 'package:quiz_app_flutter/features/domain/repository/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

part 'register_bloc.freezed.dart';
part 'register_bloc.g.dart';

@injectable
class RegisterBloc extends BaseBloc<RegisterEvent, RegisterState> {
  RegisterBloc(this._authRepository) : super(RegisterState.init()) {
    on<RegisterEvent>((event, emit) async {
      await event.when(
        onInputEmail: (email) => onInputEmail(emit, email),
        onInputUsername: (username) => onInputUsername(emit, username),
        onInputPassword: (password) => onInputPassword(emit, password),
        onPasswordVisibilityChanged: (isVisible) =>
            onPasswordVisibilityChanged(emit, isVisible),
        register: () => register(emit),
      );
    });
  }

  final AuthRepository _authRepository;

  Future<void> onInputEmail(
      Emitter<RegisterState> emit, String email) async {
    emit(
      state.copyWith(
        email: email,
        status: BaseStateStatus.idle,
      ),
    );
  }

  Future<void> onInputUsername(
      Emitter<RegisterState> emit, String username) async {
    emit(
      state.copyWith(
        username: username,
        status: BaseStateStatus.idle,
      ),
    );
  }

  Future<void> onInputPassword(
      Emitter<RegisterState> emit, String password) async {
    emit(
      state.copyWith(
        password: password,
        status: BaseStateStatus.idle,
      ),
    );
  }

  Future<void> onPasswordVisibilityChanged(
      Emitter<RegisterState> emit, bool isVisible) async {
    emit(
      state.copyWith(
        isPasswordVisible: isVisible,
        status: BaseStateStatus.idle,
      ),
    );
  }

  Future<void> register(Emitter<RegisterState> emit) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
      ),
    );

    final result = await _authRepository.register(
      request: RegisterRequest(
        email: state.email,
        username: state.username,
        password: state.password,
        roles: RoleType.user,
      ),
    );

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
        ),
      ),
    );
  }
}
