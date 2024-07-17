part of 'core_bloc.dart';

@CopyWith()
class CoreState extends BaseBlocState {
  final String username;
  final String email;

  const CoreState({
    required super.status,
    required this.username,
    required this.email,
    super.message,
    this.index = 0,
  });

  final int index;

  factory CoreState.init() {
    return const CoreState(
      status: BaseStateStatus.init,
      username: '',
      email: '',
    );
  }

  @override
  List get props => [
        status,
        index,
        message,
        username,
        email,
      ];
}
