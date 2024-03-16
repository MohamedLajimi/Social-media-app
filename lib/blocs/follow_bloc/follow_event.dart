part of 'follow_bloc.dart';

abstract class FollowEvent extends Equatable {
  const FollowEvent();

  @override
  List<Object> get props => [];
}

class FollowRequested extends FollowEvent {
  final String userId;
  final String friendId;
  const FollowRequested(this.userId, this.friendId);
  @override
  List<Object> get props => [userId, friendId];
}

