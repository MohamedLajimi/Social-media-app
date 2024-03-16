part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchRequired extends SearchEvent {
  final String name;
  const SearchRequired(this.name);

  @override
  List<Object> get props => [name];
}
