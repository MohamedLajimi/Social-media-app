part of 'password_recovery_bloc.dart';

sealed class PasswordRecoveryState extends Equatable {
  const PasswordRecoveryState();
  
  @override
  List<Object> get props => [];
}

final class PasswordRecoveryInitial extends PasswordRecoveryState {}

class EmailSentSuccessfully extends PasswordRecoveryState{
}

class  EmailSentFailure extends PasswordRecoveryState{
}