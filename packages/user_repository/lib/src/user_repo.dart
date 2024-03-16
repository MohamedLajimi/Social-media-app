import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/models/models.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<void> signIn(String email, String password);

  Future<MyUser> signUp(String name, String email, String password);

  Future<void> logOut();

  Future<void> resetPassword(String email);

  Future<MyUser> getMyUser(String myUserId);

  Future<String> uploadPicture(String file, String userid);
}
