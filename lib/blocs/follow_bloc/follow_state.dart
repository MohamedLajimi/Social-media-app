part of 'follow_bloc.dart';

sealed class FollowState extends Equatable {
  const FollowState();

  @override
  List<Object> get props => [];
}

final class FollowInitial extends FollowState {}

class UserIsFollowed extends FollowState {
  final bool isFollowed;
  const UserIsFollowed(this.isFollowed);
}

class UserIsUnfollowed extends FollowState {
  final bool isFollowed;
  const UserIsUnfollowed(this.isFollowed);
}
