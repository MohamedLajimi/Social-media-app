import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'password_recovery_event.dart';
part 'password_recovery_state.dart';

class PasswordRecoveryBloc
    extends Bloc<PasswordRecoveryEvent, PasswordRecoveryState> {
  UserRepository _userRepository;
  PasswordRecoveryBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(PasswordRecoveryInitial()) {
    on<PasswordRecoveryRequired>((event, emit) async {
      try {
        await _userRepository.resetPassword(event.email);
        emit(EmailSentSuccessfully());
      } catch (e) {
        emit(EmailSentFailure());
        log(e.toString());
        rethrow;
      }
    });
  }
}
