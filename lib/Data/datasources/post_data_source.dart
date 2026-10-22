import '../models/post_model.dart';

abstract class PostDataSource {
  Stream<List<PostModel>> getPosts();

  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String content,
  });

  Future<void> updatePost({required String postId, required String content});

  Future<void> deletePost(String postId);
}
