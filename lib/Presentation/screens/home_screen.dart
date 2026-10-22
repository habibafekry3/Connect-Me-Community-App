import 'package:connectme_app/Presentation/blocs/biometric_cubit.dart';
import 'package:connectme_app/Presentation/blocs/post_cubit.dart';
import 'package:connectme_app/Presentation/blocs/post_state.dart';
import 'package:connectme_app/Presentation/screens/map_screen.dart';
import 'package:connectme_app/Presentation/widgets/pos_card.dart';
import 'package:connectme_app/injection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/post.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _openProfileWithBiometrics(BuildContext context) async {
    final biometricCubit = getIt<BiometricCubit>();

    try {
      final authenticated = await biometricCubit.authenticate();

      if (!context.mounted) return;

      if (authenticated) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authentication failed or was cancelled.'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Opening profile failed: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Authentication error: $e')));
      }
    } finally {
      await biometricCubit.close();
    }
  }

  Future<void> _showCreatePostDialog(BuildContext context) async {
    final controller = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create a post'),
          content: TextField(
            controller: controller,
            maxLines: 4,
            maxLength: 500,
            decoration: const InputDecoration(
              hintText: "What's on your mind?",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final content = controller.text.trim();

                if (content.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please write something first.'),
                    ),
                  );
                  return;
                }

                final user = FirebaseAuth.instance.currentUser;

                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please log in again.')),
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                await context.read<PostCubit>().createPost(
                  authorId: user.uid,
                  authorName: user.displayName ?? user.email ?? 'User',
                  content: content,
                );
              },
              child: const Text('Publish'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditPostDialog(
    BuildContext context,
    PostEntity post,
  ) async {
    final controller = TextEditingController(text: post.content);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit post'),
          content: TextField(
            controller: controller,
            maxLines: 4,
            maxLength: 500,
            decoration: const InputDecoration(
              hintText: 'Edit your post...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final content = controller.text.trim();

                if (content.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Post content cannot be empty.'),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                await context.read<PostCubit>().updatePost(
                  postId: post.id,
                  content: content,
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeletePost(BuildContext context, PostEntity post) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete post?'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<PostCubit>().deletePost(post.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ConnectMe'),
        actions: [
          IconButton(
            tooltip: 'Community Map',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CommunityMapScreen()),
              );
            },
            icon: const Icon(Icons.map_outlined),
          ),
          IconButton(
            tooltip: 'My Profile',
            onPressed: () => _openProfileWithBiometrics(context),

            icon: const Icon(Icons.person_outline),
          ),
          IconButton(
            tooltip: 'Create post',
            onPressed: () => _showCreatePostDialog(context),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          if (state is PostLoaded && state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }

          if (state is PostError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PostError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PostCubit>().loadPosts();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is PostLoaded) {
            if (state.posts.isEmpty) {
              return const Center(
                child: Text('No posts yet. Tap + to create one!'),
              );
            }

            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];

                return PostCard(
                  post: post,
                  canDelete: post.authorId == currentUserId,
                  onEdit: () => _showEditPostDialog(context, post),
                  onDelete: () => _confirmDeletePost(context, post),
                );
              },
            );
          }

          return const Center(child: Text('Loading posts...'));
        },
      ),
    );
  }
}
