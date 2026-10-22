
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ProfileService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<String> uploadProfilePhoto(XFile image) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Please log in to upload a profile photo.');
    }

    final imageBytes = await image.readAsBytes();
    final imageBase64 = base64Encode(imageBytes);

    // Firestore document size is limited to 1 MiB.
    if (imageBase64.length > 700 * 1024) {
      throw Exception(
        'Image is too large. Please choose a smaller image.',
      );
    }

    await _firestore.collection('users').doc(user.uid).set({
      'id': user.uid,
      'fullName': user.displayName ?? '',
      'email': user.email ?? '',
      'profileImageBase64': imageBase64,
    }, SetOptions(merge: true));

    return imageBase64;
  }
}
