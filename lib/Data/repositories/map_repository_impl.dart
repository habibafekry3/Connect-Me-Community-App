import 'package:connectme_app/data/datasources/map_datasource.dart';
import 'package:connectme_app/domain/entities/member.dart';
import 'package:connectme_app/domain/repositories/map_repository.dart';

class CommunityMapRepositoryImpl implements CommunityMapRepository {
  final CommunityMapDataSource _dataSource;

  CommunityMapRepositoryImpl(this._dataSource);

  @override
  Stream<List<CommunityMember>> getCommunityMembers() {
    return _dataSource.getCommunityMembers();
  }
}
