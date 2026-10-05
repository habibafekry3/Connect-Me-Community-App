import '../models/post_model.dart';

abstract class FirestorePostDataSource {
  Stream<List<PostModel>> getPosts();

  Future<void> createPost({
    required String content,
  });
}