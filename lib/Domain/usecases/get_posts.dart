import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPosts {
  final PostRepository repository;

  GetPosts(this.repository);

  Stream<List<PostEntity>> call() {
    return repository.getPosts();
  }
}