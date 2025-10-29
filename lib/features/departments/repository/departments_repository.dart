import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../model/departments_model.dart';

class DepartmentRepository {
  final DioClient dioClient;

  DepartmentRepository({required this.dioClient});

  /// Refresh Token API
  Future<String> refreshToken(String oldRefreshToken) async {
    try {
      final response = await dioClient.post(
        '/auth/refresh',
        data: {'refreshToken': oldRefreshToken},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final data = response.data;
      final newToken = data['token'] as String?;
      final newRefreshToken = data['refreshToken'] as String?;

      if (newToken == null || newRefreshToken == null) {
        throw Exception('Invalid refresh response');
      }

      // TODO: Save tokens to secure storage
      return newToken;
    } on DioError catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to refresh token');
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }

  /// Fetch Departments
  Future<List<Department>> fetchDepartments(String token) async {
    try {
      final response = await dioClient.get(
        '/Org/departments',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data as List;
      return data.map((json) => Department.fromJson(json)).toList();
    } on DioError catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load departments');
    } catch (e) {
      throw Exception('Failed to load departments: $e');
    }
  }
}
