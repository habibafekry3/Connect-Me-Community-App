import 'package:connectme_app/domain/entities/member.dart';

abstract class CommunityMapRepository {
  Stream<List<CommunityMember>> getCommunityMembers();
}
