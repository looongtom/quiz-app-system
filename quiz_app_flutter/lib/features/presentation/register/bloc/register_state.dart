part of 'register_bloc.dart';

@CopyWith()
class RegisterState extends BaseBlocState {
  final String email;
  final String username;
  final String password;
  final bool isPasswordVisible;

  const RegisterState({
    required super.status,
    super.message,
    required this.email,
    required this.username,
    required this.password,
    this.isPasswordVisible = false,
  });

  factory RegisterState.init() {
    return const RegisterState(
      status: BaseStateStatus.init,
      email: '',
      username: '',
      password: '',
      isPasswordVisible: false,
    );
  }

  bool get validInput =>
      username.isNotEmpty && password.isValidPassword && email.isValidEmail;

  @override
  List get props => [
        status,
        message,
        username,
        password,
        email,
        isPasswordVisible,
      ];
}
