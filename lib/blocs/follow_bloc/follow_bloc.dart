import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:friendship_repository/friendship_repository.dart';

part 'follow_event.dart';
part 'follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  FriendshipRepository myFriendshipRepository;
  FollowBloc({required FriendshipRepository friendshipRepository})
      : myFriendshipRepository = friendshipRepository,
        super(FollowInitial()) {
    on<FollowRequested>((event, emit) async {
      try {
        bool isFollowed = await myFriendshipRepository.followingUser(
            event.userId, event.friendId);
        if (isFollowed) {
          emit(UserIsFollowed(isFollowed));
        } else {
          emit(UserIsUnfollowed(isFollowed));
        }
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    });
  }
}
