part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

class SearchLoading extends SearchState{}

class SearchResult extends SearchState {
  final List<MyUser> searchResult;
  const SearchResult(this.searchResult);

  @override
  List<Object> get props => [searchResult];
}
class SearchFailure extends SearchState{}
