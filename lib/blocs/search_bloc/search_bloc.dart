import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:friendship_repository/friendship_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  FriendshipRepository friendshipRepository;
  SearchBloc({required FriendshipRepository friendshipRepository})
      : friendshipRepository = friendshipRepository,
        super(SearchInitial()) {
    on<SearchRequired>((event, emit) async {
      try {
        emit(SearchLoading());
        List<MyUser> searchResult =
            await friendshipRepository.searchUsers(event.name);
        emit(SearchResult(searchResult));
      } catch (e) {
        log(e.toString());
        emit(SearchFailure());
        rethrow;
      }
    });
  }
}
