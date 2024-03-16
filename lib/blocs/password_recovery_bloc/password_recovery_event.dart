part of 'password_recovery_bloc.dart';

abstract class PasswordRecoveryEvent extends Equatable {
  const PasswordRecoveryEvent();

  @override
  List<Object> get props => [];
}

class PasswordRecoveryRequired extends PasswordRecoveryEvent {
  final String email;
  const PasswordRecoveryRequired(this.email);

  @override
  List<Object> get props => [email];
}
