import '../models/post_model.dart';

abstract class LocalPostDataSource {
  Stream<List<PostModel>> getPosts();

  Future<void> savePosts(List<PostModel> posts);

  Future<void> createPost({
    required String content,
  });
}