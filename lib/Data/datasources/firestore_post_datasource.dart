import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectme_app/services/firestore_service.dart';
import 'package:flutter/foundation.dart';


import '../models/post_model.dart';
import 'post_data_source.dart';

class FirestorePostDataSource implements PostDataSource {
  final FirestoreService _firestoreService;

  FirestorePostDataSource(this._firestoreService);

  @override
  Stream<List<PostModel>> getPosts() {
    // real-time updates from Firestore
    return _firestoreService.firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map(PostModel.fromFirestore).toList();
        });
  }

  @override
  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String content,
  }) async {
    debugPrint('1. Starting Firestore write');

    try {
      final docRef = await _firestoreService.firestore
          .collection('posts')
          .add({
            'authorId': authorId,
            'authorName': authorName,
            'content': content,
            'createdAt': FieldValue.serverTimestamp(),
          })
          .timeout(const Duration(seconds: 15));

      debugPrint('2. Firestore write succeeded: ${docRef.id}');
    } catch (e, stackTrace) {
      debugPrint('3. Firestore write failed: $e');
      debugPrint('$stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await _firestoreService.firestore.collection('posts').doc(postId).delete();
  }

  @override
  Future<void> updatePost({
    required String postId,
    required String content,
  }) async {
    await _firestoreService.firestore.collection('posts').doc(postId).update({
      'content': content.trim(),
    });
  }
}
