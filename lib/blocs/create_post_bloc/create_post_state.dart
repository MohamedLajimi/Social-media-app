part of 'create_post_bloc.dart';

sealed class CreatePostState extends Equatable {
  const CreatePostState();

  @override
  List<Object> get props => [];
}

class CreatePostInitial extends CreatePostState {}

class CreatePostLoading extends CreatePostState {}

class CreatePostSuccess extends CreatePostState {
  final Post post;
  const CreatePostSuccess(this.post);

  @override
  List<Object> get props => [post];
}

class CreatePostFailure extends CreatePostState {}
