import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/create_department.dart';

class CreateDepartmentRepository {
  final String baseUrl;

  CreateDepartmentRepository({required this.baseUrl});

  Future<CreateDepartment> createDepartment({
    required String name,
    required int bdoId,
    required int additionalCeoUserId,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/Org/departments');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'bdoId': bdoId,
        'additionalCeoUserId': additionalCeoUserId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {

      return CreateDepartment.fromJson(jsonDecode(response.body));
    } else {
      // Print both status code and body for debugging
      print('❌ Failed to create Department: ${response.statusCode} ${response.body}');
      throw Exception('Failed to create Department: ${response.statusCode} ${response.body}');
    }
  }

}
