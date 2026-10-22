import 'package:cloud_firestore/cloud_firestore.dart';

// Singleton pattern for FirestoreService
class FirestoreService {
  FirestoreService._internal();

  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
}
