import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/json_data_model.dart';

class JsonApiService {
  static const String baseUrl =
      "https://rdprgovapi.atyoureye.com/api/files/GetJsonData";

  static Future<JsonDataResponse?> fetchDepartmentData({
    required int month,
    required int year,
    required int departmentId,
    required int bdoId,
    required int uploadedByUserId,
  }) async {
    final url =
        "$baseUrl?month=$month&year=$year&departmentId=$departmentId&bdoId=$bdoId&uploadedByUserId=$uploadedByUserId&page=1&pageSize=1";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "accept": "*/*",
        "Authorization":
        "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwidW5pcXVlX25hbWUiOiJjZW9fYWRtaW4iLCJqdGkiOiIwZTM3NzhmMS0xOTVjLTQzZDEtYjc4Mi1mMWYxMmY3YWY4ODciLCJyb2xlIjoiQ0VPIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiQ0VPIiwicm9sZV9pZCI6IjEiLCJiZG9faWQiOiIiLCJkZXBhcnRtZW50X2lkIjoiIiwicGFyZW50X2Nlb19pZCI6IjEiLCJleHAiOjE3NTk3MzE2MTQsImlzcyI6IlJEUFJHb3ZBUEkiLCJhdWQiOiJSRFBSR292QVBJLk1vYmlsZSJ9.hjl75gFL72slDSpqFSgHsXFauuG-I0Hjstpq9aUsA_A"
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      if (body.isNotEmpty) {
        return JsonDataResponse.fromJson(body[0]);
      }
    }
    return null;
  }
}
