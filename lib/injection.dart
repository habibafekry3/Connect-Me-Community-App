import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectme_app/Presentation/blocs/biometric_cubit.dart';
import 'package:connectme_app/Presentation/blocs/map_cubit.dart';
import 'package:connectme_app/Presentation/blocs/profile_cubit.dart';
import 'package:connectme_app/data/datasources/map_datasource.dart';
import 'package:connectme_app/data/repositories/map_repository_impl.dart';
import 'package:connectme_app/data/repositories/post_repository_factory.dart';
import 'package:connectme_app/data/datasources/local_post_datasource.dart';
import 'package:connectme_app/data/repositories/post_repository_impl.dart';
import 'package:connectme_app/domain/repositories/map_repository.dart';
import 'package:connectme_app/domain/usecases/delete_post.dart';
import 'package:connectme_app/domain/usecases/get_posts.dart';
import 'package:connectme_app/domain/usecases/members.dart';
import 'package:connectme_app/domain/usecases/update_post.dart';
import 'package:connectme_app/Presentation/blocs/post_cubit.dart';
import 'package:connectme_app/services/auth_service.dart';
import 'package:connectme_app/services/biometric_service.dart';
import 'package:connectme_app/services/firestore_service.dart';
import 'package:connectme_app/services/profile_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/firestore_post_datasource.dart';
import 'domain/repositories/post_repository.dart';
import 'domain/usecases/create_post.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  debugPrint('setupDependencies CALLED');
  // Authentication
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  debugPrint('injection.dart GetIt: ${getIt.hashCode}');
  debugPrint(
    'AuthService registered here: '
    '${getIt.isRegistered<AuthService>()}',
  );
  debugPrint(
    'AuthService after registration: ${getIt.isRegistered<AuthService>()}',
  );
  // Firestore Singleton
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());

  // Post Data Source
  getIt.registerLazySingleton<FirestorePostDataSource>(
    () => FirestorePostDataSource(getIt<FirestoreService>()),
  );

  // Local cache
  getIt.registerLazySingleton<LocalPostDataSourceImpl>(
    () => LocalPostDataSourceImpl(),
  );

  // Factory for selecting the post data source
  getIt.registerLazySingleton<PostDataSourceFactory>(
    () => PostDataSourceFactory(),
  );

  // Repository
  getIt.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      PostDataSourceFactory.create(
        type: PostDataSourceType.remote,
        remoteDataSource: getIt<FirestorePostDataSource>(),
        localDataSource: getIt<LocalPostDataSourceImpl>(),
      ),
    ),
  );

  // Use Cases
  getIt.registerFactory<PostCubit>(
    () => PostCubit(
      getIt<GetPosts>(),
      getIt<CreatePost>(),
      getIt<DeletePost>(),
      getIt<UpdatePost>(),
    ),
  );

  getIt.registerLazySingleton<CreatePost>(
    () => CreatePost(getIt<PostRepository>()),
  );

  getIt.registerLazySingleton<GetPosts>(
    () => GetPosts(getIt<PostRepository>()),
  );

  getIt.registerLazySingleton<DeletePost>(
    () => DeletePost(getIt<PostRepository>()),
  );

  getIt.registerLazySingleton<UpdatePost>(
    () => UpdatePost(getIt<PostRepository>()),
  );

  debugPrint('AuthService: ${getIt.isRegistered<AuthService>()}');
  debugPrint('FirestoreService: ${getIt.isRegistered<FirestoreService>()}');
  debugPrint('PostCubit: ${getIt.isRegistered<PostCubit>()}');

  // Verify that GetIt can create PostCubit.
  final postCubit = getIt<PostCubit>();
  debugPrint('PostCubit created successfully: ${postCubit.isClosed == false}');
  postCubit.close();

  // biometric
  getIt.registerLazySingleton<BiometricService>(() => BiometricService());

  getIt.registerFactory<BiometricCubit>(
    () => BiometricCubit(getIt<BiometricService>()),
  );

  // profile
  getIt.registerLazySingleton<ProfileService>(() => ProfileService());

  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(getIt<ProfileService>()),
  );

  // Community Map Data Source
  getIt.registerLazySingleton<CommunityMapDataSource>(
    () => CommunityMapDataSource(FirebaseFirestore.instance),
  );

  // Community Map Repository
  getIt.registerLazySingleton<CommunityMapRepository>(
    () => CommunityMapRepositoryImpl(getIt<CommunityMapDataSource>()),
  );

  // Get Community Members Use Case
  getIt.registerLazySingleton<GetCommunityMembers>(
    () => GetCommunityMembers(getIt<CommunityMapRepository>()),
  );

  // Community Map Cubit
  getIt.registerFactory<CommunityMapCubit>(
    () => CommunityMapCubit(getIt<GetCommunityMembers>()),
  );
}
