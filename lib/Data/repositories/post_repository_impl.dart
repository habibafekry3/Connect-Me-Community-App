import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_data_source.dart';

class PostRepositoryImpl implements PostRepository {
final PostDataSource _dataSource;

PostRepositoryImpl(this._dataSource);

  @override
  Stream<List<PostEntity>> getPosts() {
    return _dataSource.getPosts();
  }

  @override
  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String content,
  }) {
    return _dataSource.createPost(
      authorId: authorId,
      authorName: authorName,
      content: content,
    );
  }

  @override
  Future<void> updatePost({required String postId, required String content}) {
    return _dataSource.updatePost(postId: postId, content: content);
  }

  @override
  Future<void> deletePost(String postId) {
    return _dataSource.deletePost(postId);
  }
}
