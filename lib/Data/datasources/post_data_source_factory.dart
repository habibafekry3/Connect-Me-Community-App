

import '../../services/firestore_service.dart';
import 'firestore_post_datasource.dart';
import 'local_post_datasource.dart';
import 'post_data_source.dart';

enum PostDataSourceType {
  remote,
  local,
}

class PostDataSourceFactory {
  final FirestoreService _firestoreService;
  final LocalPostDataSourceImpl _localDataSource;

  PostDataSourceFactory({
    required FirestoreService firestoreService,
    required LocalPostDataSourceImpl localDataSource,
  }) : _firestoreService = firestoreService,
       _localDataSource = localDataSource;

  PostDataSource create(PostDataSourceType type) {
    switch (type) {
      case PostDataSourceType.remote:
        return FirestorePostDataSource(_firestoreService);

      case PostDataSourceType.local:
        return _localDataSource;
    }
  }
}
