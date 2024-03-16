part of 'create_post_bloc.dart';

abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object> get props => [];
}

class CreatePostRequired extends CreatePostEvent {
  final String file;
  final Post post;

  const CreatePostRequired(this.post, this.file);

  @override
  List<Object> get props => [post, file];
}
