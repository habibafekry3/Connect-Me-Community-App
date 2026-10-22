
import '../../domain/entities/post.dart';

abstract class PostState {
  const PostState();
}

class PostInitial extends PostState {
  const PostInitial();
}

class PostLoading extends PostState {
  const PostLoading();
}

class PostLoaded extends PostState {
  final List<PostEntity> posts;
  final bool isCreating;
  final String? message;
  final bool hasError;

  const PostLoaded(
    this.posts, {
    this.isCreating = false,
    this.message,
    this.hasError = false,
  });
}

class PostError extends PostState {
  final String message;

  const PostError(this.message);
}
