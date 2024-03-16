import 'package:equatable/equatable.dart';
import 'package:friendship_repository/friendship_repository.dart';

class Friendship extends Equatable {
  final String friendshipId;
  final String userId;
  List<String> friends;

  Friendship({required this.friendshipId,required this.userId, required this.friends});

  static Friendship empty(String friendshipId,String userId) {
    return Friendship(friendshipId: friendshipId,userId: userId, friends: List.empty());
  }

  FriendshipEntity toEntity() {
    return FriendshipEntity(friendshipId: friendshipId,userId: userId, friends: friends);
  }

  static Friendship fromEntity(FriendshipEntity entity) {
    return Friendship(friendshipId: entity.friendshipId,userId: entity.userId, friends: entity.friends);
  }

  @override
  List<Object?> get props => [friendshipId,userId, friends];
}
