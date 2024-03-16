part of 'react_to_post_bloc.dart';

sealed class ReactToPostState extends Equatable {
  const ReactToPostState();

  @override
  List<Object> get props => [];
}

final class ReactToPostInitial extends ReactToPostState {}

class PostIsLiked extends ReactToPostState {
  final bool isLiked;
  const PostIsLiked(this.isLiked);
    @override
  List<Object> get props => [isLiked];
}
class PostIsUnliked extends ReactToPostState {
  final bool isLiked;
  const PostIsUnliked(this.isLiked);
    @override
  List<Object> get props => [isLiked];
}
