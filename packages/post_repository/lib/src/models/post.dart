import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';

// ignore: must_be_immutable
class Post extends Equatable {
  String postId;
  String postContent;
  String picture;
  DateTime createdAt;
  MyUser myUser;
  int likes;
  List<String> peopleWhoLiked;


  Post({
    required this.postId,
    required this.postContent,
    required this.picture,
    required this.createdAt,
    required this.myUser,
    required this.likes,
    required this.peopleWhoLiked,
    
  });

  static final empty = Post(
      postId: '',
      postContent: '',
      picture: '',
      createdAt: DateTime.now(),
      myUser: MyUser.empty,
      likes: 0,
      peopleWhoLiked: List.empty(),
      
      );

  bool get isEmpty => this == Post.empty;

  bool get isNotEmpty => this != Post.empty;

  Post copyWith(
      {String? postId,
      String? postContent,
      String? picture,
      DateTime? createdAt,
      MyUser? myUser,
      int? likes,
      List<String>? peopleWhoLiked,
      }) {
    return Post(
        postId: postId ?? this.postId,
        postContent: postContent ?? this.postContent,
        picture: picture ?? this.picture,
        createdAt: createdAt ?? this.createdAt,
        myUser: myUser ?? this.myUser,
        likes: likes?? this.likes,
        peopleWhoLiked: peopleWhoLiked ?? this.peopleWhoLiked,
      );
  }

  PostEntity toEntity() {
    return PostEntity(
        postId: postId,
        postContent: postContent,
        picture: picture,
        createdAt: createdAt,
        myUser: myUser,
        likes: likes,
        peopleWhoLiked: peopleWhoLiked,
      );
  }

  static Post fromEntity(PostEntity entity) {
    return Post(
        postId: entity.postId,
        postContent: entity.postContent,
        picture: entity.picture,
        createdAt: entity.createdAt,
        myUser: entity.myUser,
        likes: entity.likes,
        peopleWhoLiked: entity.peopleWhoLiked,
      );
  }

  @override
  List<Object?> get props =>
      [postId, postContent, picture, createdAt, myUser, likes, peopleWhoLiked];
}
