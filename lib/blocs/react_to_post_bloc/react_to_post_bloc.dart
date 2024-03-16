import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';

part 'react_to_post_event.dart';
part 'react_to_post_state.dart';

class ReactToPostBloc extends Bloc<ReactToPostEvent, ReactToPostState> {
  PostRepository myPostRepository;
  ReactToPostBloc({required PostRepository postRepository})
      : myPostRepository = postRepository,
        super(ReactToPostInitial()) {
    on<UserReactedToPost>((event, emit) async {
      try {
        bool isLiked  =
            await myPostRepository.reactPost(event.postId, event.userId);
        if(isLiked){
          emit(PostIsLiked(isLiked));
        }
        else if(!isLiked){
          emit(PostIsUnliked(isLiked));
        }
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    });
  }
}
