part of 'core_bloc.dart';

@freezed
class CoreEvent with _$CoreEvent {
  const factory CoreEvent.init() = CoreInit;
  const factory CoreEvent.enterQuizWithQR() = EnterQuizWithQR;
  const factory CoreEvent.logout() = Logout;
}
