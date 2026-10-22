import '../repositories/post_repository.dart';

class UpdatePost {
  final PostRepository _repository;

  UpdatePost(this._repository);

  Future<void> call({
    required String postId,
    required String content,
  }) {
    return _repository.updatePost(
      postId: postId,
      content: content,
    );
  }
}