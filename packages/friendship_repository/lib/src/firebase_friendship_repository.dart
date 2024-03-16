import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendship_repository/friendship_repository.dart';
import 'package:user_repository/user_repository.dart';

class FirebaseFriendshipRepository implements FriendshipRepository {
  final friendshipCollection =
      FirebaseFirestore.instance.collection('friendship');
  final usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Future<List<MyUser>> searchUsers(String name) async {
    try {
      List<MyUser> searchResult = [];
      String firstWord = name.split(' ').first.toLowerCase();
      String lastWord = name.split(' ').last.toLowerCase();
      if (firstWord.isNotEmpty) {
        searchResult = await usersCollection
            .where('firstName', isEqualTo: firstWord)
            .get()
            .then((value) => value.docs
                .map((e) =>
                    MyUser.fromEntity(MyUserEntity.fromDocument(e.data())))
                .toList());
        if (searchResult.isEmpty) {
          searchResult = await usersCollection
              .where('lastName', isEqualTo: firstWord)
              .get()
              .then((value) => value.docs
                  .map((e) =>
                      MyUser.fromEntity(MyUserEntity.fromDocument(e.data())))
                  .toList());
        }
      } else if (firstWord.isNotEmpty && lastWord.isNotEmpty) {
        searchResult = await usersCollection
            .where('firstName', isEqualTo: firstWord)
            .where('lastName', isEqualTo: firstWord)
            .get()
            .then((value) => value.docs
                .map((e) =>
                    MyUser.fromEntity(MyUserEntity.fromDocument(e.data())))
                .toList());
      }
      // If only first name is provided, search by first name

      return searchResult;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<MyUser>> getFollowingList(String userId) async {
    try {
      Friendship friendship = await friendshipCollection
          .where('userId', isEqualTo: userId)
          .get()
          .then((doc) => Friendship.fromEntity(
              FriendshipEntity.fromDocument(doc.docs.first.data())));
      List<MyUser> followingList = [];
      for (var userId in friendship.friends) {
        followingList.add(await usersCollection.doc(userId).get().then((doc) =>
            MyUser.fromEntity(MyUserEntity.fromDocument(doc.data()!))));
      }
      return followingList;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<MyUser>> getFollowersList(String userId) async {
    try {
      QuerySnapshot querySnapshot = await friendshipCollection
          .where('friends', arrayContains: userId)
          .get();
      List<MyUser> followingList = [];
      for (var doc in querySnapshot.docs) {
        String id = doc.get('userId');
        followingList.add(await usersCollection.doc(id).get().then((doc) =>
            MyUser.fromEntity(MyUserEntity.fromDocument(doc.data()!))));
      }
      return followingList;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> followingUser(String userId, String friendId) async {
    try {
      bool isFollowed = false;
      QuerySnapshot querySnapshot =
          await friendshipCollection.where('userId', isEqualTo: userId).get();
      DocumentSnapshot doc = querySnapshot.docs.first;
      List<dynamic> friends = doc['friends'];
      if (!friends.contains(friendId)) {
        friends.add(friendId);
        await friendshipCollection.doc(doc.id).update({'friends': friends});
        isFollowed = true;
      } else if (friends.contains(friendId)) {
        isFollowed = false;
        friends.remove(friendId);
        await friendshipCollection.doc(doc.id).update({'friends': friends});
      }
      return isFollowed;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
