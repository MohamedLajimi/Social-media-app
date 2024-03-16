import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

// ignore: must_be_immutable
class PostEntity extends Equatable {
  String postId;
  String postContent;
  String picture;
  DateTime createdAt;
  MyUser myUser;
  int likes;
  List<String> peopleWhoLiked;

  PostEntity({
    required this.postId,
    required this.postContent,
    required this.picture,
    required this.createdAt,
    required this.myUser,
    required this.likes,
    required this.peopleWhoLiked,
  });

  Map<String, dynamic> toDocument() {
    return {
      'id': postId,
      'postContent': postContent,
      'picture': picture,
      'createdAt': createdAt,
      'user': myUser.toEntity().toDocument(),
      'likes': likes,
      'peopleWhoLiked': peopleWhoLiked,
    };
  }

  static PostEntity fromDocument(Map<String, dynamic> doc) {
    return PostEntity(
      postId: doc['id'] as String,
      postContent: doc['postContent'] as String,
      picture: doc['picture'] as String,
      createdAt: (doc['createdAt']).toDate(),
      myUser: MyUser.fromEntity(MyUserEntity.fromDocument(doc['user'])),
      likes: doc['likes'],
      peopleWhoLiked: List<String>.from(doc['peopleWhoLiked'] as List<dynamic>),
    );
  }

  @override
  List<Object?> get props => [
        postId,
        postContent,
        picture,
        createdAt,
        myUser,
        likes,
        peopleWhoLiked,
      ];
}
