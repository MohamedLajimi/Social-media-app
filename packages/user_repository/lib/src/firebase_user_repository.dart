import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:friendship_repository/friendship_repository.dart';
import 'package:user_repository/src/entities/my_user_entity.dart';
import 'package:user_repository/src/models/my_user.dart';
import 'package:user_repository/src/user_repo.dart';
import 'package:uuid/uuid.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth;
  final userCollection = FirebaseFirestore.instance.collection('users');
  @override
  Future<MyUser> signUp(String name, String email, String password) async {
    try {
      List<String> fullName = name.toLowerCase().split(' ');
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final myUser = MyUser(
          id: userCredential.user!.uid,
          firstName: fullName.first,
          lastName: fullName.last,
          email: email,
          picture: "");
      await userCollection.doc(myUser.id).set(myUser.toEntity().toDocument());
      final friendship = Friendship.empty(const Uuid().v1(), myUser.id);
      await FirebaseFirestore.instance
          .collection('friendship')
          .doc(friendship.friendshipId)
          .set(friendship.toEntity().toDocument());
      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> getMyUser(String myUserId) async {
    try {
      return userCollection.doc(myUserId).get().then((value) =>
          MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser;
      return user;
    });
  }

  @override
  Future<String> uploadPicture(String file, String userId) async {
    try {
      File imageFile = File(file);
      Reference firebaseStorageReference = FirebaseStorage.instance
          .ref()
          .child('$userId/ProfilePicture/${userId}_lead');
      await firebaseStorageReference.putFile(imageFile);
      String url = await firebaseStorageReference.getDownloadURL();
      await userCollection.doc(userId).update({'picture': url});
      return url;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
