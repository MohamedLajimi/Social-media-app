part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
  @override
  List<Object> get props => [];
}

class SignUpRequired extends SignUpEvent {
  final String name;
  final String email;
  final String password;
  const SignUpRequired(this.name, this.email, this.password);
}
