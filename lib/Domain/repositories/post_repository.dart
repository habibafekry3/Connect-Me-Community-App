import '../entities/post.dart';

abstract class PostRepository {
  Stream<List<PostEntity>> getPosts();

  Future<void> createPost({
    required String content,
  });
}