import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:quiz_app_flutter/base/bloc/base_bloc.dart';
import 'package:quiz_app_flutter/base/bloc/base_bloc_state.dart';
import 'package:quiz_app_flutter/base/bloc/bloc_status.dart';
import 'package:quiz_app_flutter/common/constants/auth_constants.dart';
import 'package:quiz_app_flutter/common/local_data/secure_storage.dart';
import 'package:quiz_app_flutter/di/di_setup.dart';

part 'splash_event.dart';

part 'splash_state.dart';

part 'splash_bloc.freezed.dart';

part 'splash_bloc.g.dart';

@injectable
class SplashBloc extends BaseBloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState.init()) {
    on<SplashEvent>((event, emit) async {
      await event.when(
        init: () => init(emit),
      );
    });
  }

  Future init(Emitter<SplashState> emit) async {
    final token = await getIt<SecureStorage>().get(AuthConstants.token);
    if (token == null) {
      emit(
        state.copyWith(
          actionState: SplashActionState.goToLogin,
        ),
      );
    } else {
      emit(
        state.copyWith(
          actionState: SplashActionState.goToMain,
        ),
      );
    }
  }
}
