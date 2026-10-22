import 'package:connectme_app/domain/entities/member.dart';
import 'package:connectme_app/domain/repositories/map_repository.dart';

class GetCommunityMembers {
  final CommunityMapRepository _repository;

  GetCommunityMembers(this._repository);

  Stream<List<CommunityMember>> call() {
    return _repository.getCommunityMembers();
  }
}
