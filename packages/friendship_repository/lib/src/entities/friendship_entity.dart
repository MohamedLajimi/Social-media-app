import 'package:equatable/equatable.dart';

class FriendshipEntity extends Equatable {
  final String friendshipId;
  final String userId;
  List<String> friends;
  FriendshipEntity(
      {required this.friendshipId, required this.userId, required this.friends});

  Map<String, dynamic> toDocument() {
    return {'friendshipId': friendshipId, 'userId': userId, 'friends': friends};
  }

  static FriendshipEntity fromDocument(Map<String, dynamic> doc) {
    return FriendshipEntity(
        friendshipId: doc['friendshipId'] as String,
        userId: doc['userId'] as String,
        friends: doc['friends'] as List<String>);
  }

  @override
  List<Object?> get props => [friendshipId,userId, friends];
}
