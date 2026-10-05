import '../repositories/post_repository.dart';

class CreatePost {
  final PostRepository repository;

  CreatePost(this.repository);

  Future<void> call({
    required String content,
  }) {
    return repository.createPost(
      content: content,
    );
  }
}