// import '../../domain/repositories/auth_repository.dart';
// import '../datasources/auth_remote_data_source.dart';
// import '../../../../core/storage/local_storage.dart';
// import '../../domain/entities/user.dart';
//
// class AuthRepositoryImpl implements AuthRepository {
//   final AuthRemoteDataSource remoteDataSource;
//   final LocalStorage localStorage;
//   AuthRepositoryImpl({required this.remoteDataSource, required this.localStorage});
//
//   @override
//   Future<AuthResult> login(String email, String password) async {
//     try {
//       final data = await remoteDataSource.login(email, password);
//       final token = data['token'] as String?;
//       final userMap = data['user'] as Map<String, dynamic>?;
//       if (token != null) {
//         await localStorage.saveSecureToken(token);
//       }
//       final user = userMap != null ? User.fromJson(userMap) : null;
//       return AuthResult(success: true, token: token, user: user);
//     } catch (e) {
//       return AuthResult(success: false, error: e.toString());
//     }
//   }
//
//   @override
//   Future<AuthResult> register(String email, String password) async {
//     try {
//       final data = await remoteDataSource.register(email, password);
//       final token = data['token'] as String?;
//       final userMap = data['user'] as Map<String, dynamic>?;
//       if (token != null) await localStorage.saveSecureToken(token);
//       final user = userMap != null ? User.fromJson(userMap) : null;
//       return AuthResult(success: true, token: token, user: user);
//     } catch (e) {
//       return AuthResult(success: false, error: e.toString());
//     }
//   }
//
//   @override
//   Future<void> logout() async {
//     await localStorage.deleteSecureToken();
//   }
// }
