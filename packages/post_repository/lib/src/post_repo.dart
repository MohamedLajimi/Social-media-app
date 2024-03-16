import 'package:post_repository/post_repository.dart';

abstract class PostRepository {
  Future<Post> createPost(Post post, String file);

  Future<List<Post>> getPost(String userId);

  Future<bool> reactPost(String postId, String userId);
}
