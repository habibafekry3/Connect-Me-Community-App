import '../repositories/post_repository.dart';

class CreatePost {
  final PostRepository repository;

  CreatePost(this.repository);

  Future<void> call({
    required String authorId,
    required String authorName,
    required String content,
  }) {
    return repository.createPost(
      authorId: authorId,
      authorName: authorName,
      content: content,
    );
  }
}