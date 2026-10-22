
import '../datasources/firestore_post_datasource.dart';
import '../datasources/local_post_datasource.dart';
import '../datasources/post_data_source.dart';

enum PostDataSourceType {
  remote,
  local,
}

// Factory Pattern: selects the required post data source.
class PostDataSourceFactory {
  static PostDataSource create({
    required PostDataSourceType type,
    required FirestorePostDataSource remoteDataSource,
    required LocalPostDataSourceImpl localDataSource,
  }) {
    switch (type) {
      case PostDataSourceType.remote:
        return remoteDataSource;

      case PostDataSourceType.local:
        return localDataSource;
    }
  }
}
