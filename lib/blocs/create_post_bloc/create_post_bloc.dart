import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';


part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final PostRepository postRepository;
  CreatePostBloc({required PostRepository postRepository})
      : postRepository = postRepository,
        super(CreatePostInitial()) {
    on<CreatePostRequired>((event, emit) async {
      try {
        emit(CreatePostLoading());
        Post post = await postRepository.createPost(event.post, event.file);
        emit(CreatePostSuccess(post));
      } catch (e) {
        emit(CreatePostFailure());
        log(e.toString());
        rethrow;
      }
    });
  }
}
