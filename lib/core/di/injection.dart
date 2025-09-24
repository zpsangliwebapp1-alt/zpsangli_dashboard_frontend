// lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Register all dependencies here
  getIt.registerLazySingleton<AuthProvider>(() => AuthProvider());

  // If you had API clients, repositories, etc., register them here too:
  // getIt.registerLazySingleton<ApiClient>(() => ApiClientImpl());
  // getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt()));
}
