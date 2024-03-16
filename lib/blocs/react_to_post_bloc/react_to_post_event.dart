part of 'react_to_post_bloc.dart';

abstract class ReactToPostEvent extends Equatable {
  const ReactToPostEvent();

  @override
  List<Object> get props => [];
}

class UserReactedToPost extends ReactToPostEvent{
  final String postId;
  final String userId;
  const UserReactedToPost(this.postId, this.userId);
  @override
  List<Object> get props => [postId, userId];
}
