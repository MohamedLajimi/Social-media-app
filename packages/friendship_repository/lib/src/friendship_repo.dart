import 'package:user_repository/user_repository.dart';

abstract class FriendshipRepository {
  Future<List<MyUser>> searchUsers(String name);

  Future<List<MyUser>> getFollowingList(String userId);

  Future<List<MyUser>> getFollowersList(String userId);

  Future<bool> followingUser(String userId, String friendId);

 
}
