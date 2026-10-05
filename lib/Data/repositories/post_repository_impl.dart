import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  @override
  Stream<List<PostEntity>> getPosts() {
    throw UnimplementedError();
  }

  @override
  Future<void> createPost({
    required String content,
  }) {
    throw UnimplementedError();
  }
}