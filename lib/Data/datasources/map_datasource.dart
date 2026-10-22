import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectme_app/domain/entities/member.dart';

class CommunityMapDataSource {
  final FirebaseFirestore _firestore;

  CommunityMapDataSource(this._firestore);

  Stream<List<CommunityMember>> getCommunityMembers() {
    return _firestore.collection('community_locations').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return CommunityMember(
          id: doc.id,
          name: data['displayName'] as String? ?? 'Community Member',
          city: data['city'] as String? ?? '',
          latitude: (data['latitude'] as num).toDouble(),
          longitude: (data['longitude'] as num).toDouble(),
        );
      }).toList();
    });
  }
}
