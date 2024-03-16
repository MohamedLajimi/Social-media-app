part of 'get_post_bloc.dart';

sealed class GetPostEvent extends Equatable {
  const GetPostEvent();

  @override
  List<Object> get props => [];
}

class GetPost extends GetPostEvent {
  final String userId;
  const GetPost(this.userId);
    @override
  List<Object> get props => [userId];
}
