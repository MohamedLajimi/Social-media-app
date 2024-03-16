import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:post_repository/post_repository.dart';
import 'package:uuid/uuid.dart';

class FirebasePostRepository implements PostRepository {
  final postCollection = FirebaseFirestore.instance.collection('posts');
  final friendshipCollection =
      FirebaseFirestore.instance.collection('friendship');

  @override
  Future<Post> createPost(Post post, String file) async {
    try {
      post.postId = const Uuid().v1();
      post.createdAt = DateTime.now();
      post.likes = 0;
      if (file.isNotEmpty) {
        File imageFile = File(file);
        Reference firebaseStorageReference = FirebaseStorage.instance
            .ref()
            .child('/${post.myUser.id}/PostImages/${post.postId}_post');
        await firebaseStorageReference.putFile(imageFile);
        String url = await firebaseStorageReference.getDownloadURL();
        post.picture = url;
      }

      await postCollection.doc(post.postId).set(post.toEntity().toDocument());
      return post;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Post>> getPost(String userId) async {
    try {
      List<Post> allPosts = await postCollection.get().then((value) => value
          .docs
          .map((e) => Post.fromEntity(PostEntity.fromDocument(e.data())))
          .toList());
      QuerySnapshot querySnapshot =
          await friendshipCollection.where('userId', isEqualTo: userId).get();
      List<dynamic> friends = querySnapshot.docs.first.get('friends');
      List<Post> posts = allPosts
          .where((post) =>
              friends.contains(post.myUser.id) || post.myUser.id == userId)
          .toList();
      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return posts;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> reactPost(String postId, String userId) async {
    try {
      bool isLiked = false;
      Post post = await postCollection.doc(postId).get().then(
          (value) => Post.fromEntity(PostEntity.fromDocument(value.data()!)));
      if (!post.peopleWhoLiked.contains(userId)) {
        isLiked = true;
        post.peopleWhoLiked.add(userId);
        post.likes += 1;
        await postCollection.doc(postId).update(post.toEntity().toDocument());
      } else if (post.peopleWhoLiked.contains(userId)) {
        isLiked = false;
        post.peopleWhoLiked.remove(userId);
        post.likes -= 1;
        await postCollection.doc(postId).update(post.toEntity().toDocument());
      }
      return isLiked;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
