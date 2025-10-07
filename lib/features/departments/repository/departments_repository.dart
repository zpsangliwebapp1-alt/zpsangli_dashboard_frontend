import 'package:zp_sangali_dashboard_flutter/core/network/dio_client.dart';
import '../model/departments_model.dart';
import 'package:dio/dio.dart'; // <-- Add this import

class DepartmentRepository {
  final DioClient dioClient;

  DepartmentRepository(this.dioClient);
  Future<String> refreshToken(String oldRefreshToken) async {
    try {
      final response = await dioClient.dio.post(
        '/auth/refresh',
        data: {
          'refreshToken': oldRefreshToken,
        },
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

      // TODO: Save newToken & newRefreshToken in secure storage
      return newToken;
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }


  Future<List<Department>> fetchDepartments(String token) async {
    try {
      final response = await dioClient.dio.get(
        '/Org/departments',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final data = response.data as List;
      return data.map((json) => Department.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load departments: $e');
    }
  }
}
