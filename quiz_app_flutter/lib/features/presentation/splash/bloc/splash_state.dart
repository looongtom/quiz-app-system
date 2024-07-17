part of 'splash_bloc.dart';

@CopyWith()
class SplashState extends BaseBlocState {
  final SplashActionState actionState;

  const SplashState({
    required super.status,
    super.message,
    required this.actionState,
  });

  factory SplashState.init() => const SplashState(
        actionState: SplashActionState.init,
        status: BaseStateStatus.init,
      );

  @override
  List get props => [
        status,
        message,
        actionState,
      ];
}

enum SplashActionState {
  init,
  goToLogin,
  goToMain,
}
