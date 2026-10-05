import 'package:get_it/get_it.dart';

import 'domain/repositories/post_repository.dart';
import 'domain/usecases/create_post.dart';
import 'domain/usecases/get_posts.dart';
import 'services/auth_service.dart';
import 'data/repositories/post_repository_impl.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<AuthService>(() => AuthService());

  getIt.registerLazySingleton<PostRepository>(() => PostRepositoryImpl());

  // GetPosts >  PostRepository  > PostRepositoryImpl
  getIt.registerLazySingleton<GetPosts>(
    () => GetPosts(getIt<PostRepository>()),
  );

  getIt.registerLazySingleton<CreatePost>(
    () => CreatePost(getIt<PostRepository>()),
  );
}
