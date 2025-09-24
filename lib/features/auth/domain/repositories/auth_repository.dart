import '../entities/user.dart';

abstract class AuthRepository {
  Future<AuthResult> login(String email, String password);
  Future<AuthResult> register(String email, String password);
  Future<void> logout();
}

class AuthResult {
  final bool success;
  final String? token;
  final User? user;
  final String? error;
  AuthResult({required this.success, this.token, this.user, this.error});
}
