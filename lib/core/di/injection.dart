// lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import '../../features/auth/provider/auth_provider.dart';
import '../../features/auth/repository/auth_repository.dart';
import '../network/dio_client.dart';

final getIt = GetIt.instance;
final DioClient _dioClient = DioClient();

Future<void> initDependencies() async {
  // Register Repository
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(_dioClient));

  // Register Provider (depends on AuthRepository)
  getIt.registerLazySingleton<AuthProvider>(
        () => AuthProvider(getIt<AuthRepository>()),
  );

  // If you had other dependencies:
  // getIt.registerLazySingleton<ApiClient>(() => ApiClientImpl());
  // getIt.registerLazySingleton<UserRepository>(() => UserRepository(getIt()));
}
