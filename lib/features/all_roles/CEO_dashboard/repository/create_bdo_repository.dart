import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/bdo_model.dart';

class BdoRepository {
  final String baseUrl;

  BdoRepository({required this.baseUrl});

  Future<Bdo> createBdo({required String name, required String token}) async {
    final url = Uri.parse('$baseUrl/api/Org/bdos');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Bdo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create BDO: ${response.body}');
    }
  }
}
