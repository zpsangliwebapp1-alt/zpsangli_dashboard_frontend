import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class AuthRepository {
  final DioClient dioClient;

  AuthRepository(this.dioClient);

  /// 🔹 Login API
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await dioClient.dio.post(
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

  /// 🔹 Refresh Token API
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await dioClient.dio.post(
        '/auth/refresh',
        data: {
          "refreshToken": refreshToken,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioError catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Refresh token failed',
      );
    }
  }
}
