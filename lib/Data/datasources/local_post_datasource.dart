
import '../models/post_model.dart';
import 'post_data_source.dart';

class LocalPostDataSourceImpl implements PostDataSource {
  final List<PostModel> _posts = [];

  @override
  Stream<List<PostModel>> getPosts() async* {
    yield List.unmodifiable(_posts);
  }

  Future<void> savePosts(List<PostModel> posts) async {
    _posts
      ..clear()
      ..addAll(posts);
  }

  @override
  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String content,
  }) async {
    throw UnsupportedError(
      'Creating posts is not supported by the local cache.',
    );
  }

  @override
  Future<void> updatePost({
    required String postId,
    required String content,
  }) async {
    throw UnsupportedError(
      'Updating posts is not supported by the local cache.',
    );
  }

  @override
  Future<void> deletePost(String postId) async {
    throw UnsupportedError(
      'Deleting posts is not supported by the local cache.',
    );
  }
}
