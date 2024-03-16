part of 'get_post_bloc.dart';

sealed class GetPostState extends Equatable {
  const GetPostState();
  
  @override
  List<Object> get props => [];
}

final class GetPostInitial extends GetPostState {}

class GetPostLoading extends GetPostState{}

class GetPostSuccess extends GetPostState {
  final List<Post> list;
  const GetPostSuccess(this.list);
}

class GetPostFailure extends GetPostState {}