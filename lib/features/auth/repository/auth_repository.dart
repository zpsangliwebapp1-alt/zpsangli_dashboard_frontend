import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class AuthRepository {
  final DioClient dioClient;

  AuthRepository(this.dioClient);

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await dioClient.post(
        '/auth/login',
        data: {
          "username": username,
          "password": password,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioError catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await dioClient.post(
        '/auth/refresh',
        data: {"refreshToken": refreshToken},
      );
      return response.data as Map<String, dynamic>;
    } on DioError catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Refresh token failed');
    }
  }

  Future<String?> getUsernameById(int userId) async {
    try {
      final response = await dioClient.get('/users/$userId'); // ✅ depends on your API path
      final data = response.data;
      return data['username'] ?? data['name'] ?? null;
    } catch (e) {
      return null;
    }
  }
}
