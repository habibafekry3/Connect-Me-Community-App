

import 'package:connectme_app/domain/repositories/post_repository.dart';

class DeletePost {
  final PostRepository _repository;

  DeletePost(this._repository);

  Future<void> call(String postId) {
    return _repository.deletePost(postId);
  }
}
