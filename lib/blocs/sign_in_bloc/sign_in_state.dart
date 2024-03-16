part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();
  @override
  List<Object?> get props => [];
}

final class SignInInitial extends SignInState {}

class SignInSuccess extends SignInState {}

class SignInFailure extends SignInState {}

class SignInProcess extends SignInState {}
