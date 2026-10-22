import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/post.dart';
import '../../domain/usecases/create_post.dart';
import '../../domain/usecases/delete_post.dart';
import '../../domain/usecases/get_posts.dart';
import '../../domain/usecases/update_post.dart';
import 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final GetPosts _getPosts;
  final CreatePost _createPost;
  final DeletePost _deletePost;
  final UpdatePost _updatePost;

  StreamSubscription<List<PostEntity>>? _postsSubscription;

  List<PostEntity> _posts = [];
  bool _isCreating = false;
  bool _isDeleting = false;
  bool _isUpdating = false;
  bool _hasLoadedPosts = false;

  PostCubit(
    this._getPosts,
    this._createPost,
    this._deletePost,
    this._updatePost,
  ) : super(const PostInitial());

  void loadPosts() {
    emit(const PostLoading());

    _postsSubscription?.cancel();

    _postsSubscription = _getPosts().listen(
      (posts) {
        _posts = posts;
        _hasLoadedPosts = true;

        emit(PostLoaded(_posts, isCreating: _isCreating));
      },
      onError: (error) {
        if (!_hasLoadedPosts) {
          emit(const PostError('Failed to load posts. Please try again.'));
        } else {
          emit(
            PostLoaded(
              _posts,
              isCreating: _isCreating,
              message: 'Failed to refresh posts.',
              hasError: true,
            ),
          );
        }
      },
    );
  }

  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String content,
  }) async {
    if (content.trim().isEmpty) {
      emit(
        PostLoaded(
          _posts,
          message: 'Post content cannot be empty.',
          hasError: true,
        ),
      );
      return;
    }

    if (_isCreating) return;

    _isCreating = true;

    emit(PostLoaded(_posts, isCreating: true));

    try {
      await _createPost(
        authorId: authorId,
        authorName: authorName,
        content: content.trim(),
      );

      if (!isClosed) {
        emit(PostLoaded(_posts, message: 'Post published successfully!'));
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          PostLoaded(
            _posts,
            message: 'Failed to create post: $e',
            hasError: true,
          ),
        );
      }
    } finally {
      _isCreating = false;

      if (!isClosed && state is PostLoaded) {
        final currentState = state as PostLoaded;

        emit(
          PostLoaded(
            _posts,
            message: currentState.message,
            hasError: currentState.hasError,
          ),
        );
      }
    }
  }

  Future<void> deletePost(String postId) async {
    if (_isDeleting) return;

    _isDeleting = true;

    try {
      await _deletePost(postId);

      if (!isClosed) {
        emit(PostLoaded(_posts, message: 'Post deleted successfully!'));
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          PostLoaded(
            _posts,
            message: 'Failed to delete post: $e',
            hasError: true,
          ),
        );
      }
    } finally {
      _isDeleting = false;
    }
  }

  Future<void> updatePost({
    required String postId,
    required String content,
  }) async {
    if (content.trim().isEmpty) {
      emit(
        PostLoaded(
          _posts,
          message: 'Post content cannot be empty.',
          hasError: true,
        ),
      );
      return;
    }

    if (_isUpdating) return;

    _isUpdating = true;

    try {
      await _updatePost(postId: postId, content: content.trim());

      if (!isClosed) {
        emit(PostLoaded(_posts, message: 'Post updated successfully!'));
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          PostLoaded(
            _posts,
            message: 'Failed to update post: $e',
            hasError: true,
          ),
        );
      }
    } finally {
      _isUpdating = false;
    }
  }

  @override
  Future<void> close() async {
    await _postsSubscription?.cancel();
    return super.close();
  }
}
