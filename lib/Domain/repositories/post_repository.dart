
import '../entities/post.dart';

abstract class PostRepository {
  Stream<List<PostEntity>> getPosts();

  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String content,
  });

  Future<void> updatePost({
    required String postId,
    required String content,
  });

  Future<void> deletePost(String postId);
}
