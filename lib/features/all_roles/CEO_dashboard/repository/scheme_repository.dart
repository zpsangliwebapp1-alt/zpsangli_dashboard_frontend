import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/dio_client.dart';

class SchemeRepository {
  final DioClient dioClient;

  SchemeRepository({required this.dioClient});

  // ✅ POST: Submit a new Scheme Application
  Future<Map<String, dynamic>> submitSchemeApplication({
    required String applicantName,
    required String fatherOrHusbandName,
    required String mobileNumber,
    required String email,
    required String aadhaarNumber,
    required String address,
    required String villageName,
    required String taluka,
    required String district,
    required int age,
    required String gender,
    required String caste,
    required int annualIncome,
    required String schemeName,
    required String purpose,
    required List<String> requiredDocuments,
    required String bankAccountNumber,
    required String ifscCode,
    required bool consentAccepted,
  }) async {
    try {
      final response = await dioClient.post(
        '/applications/schemes',
        data: {
          "applicantName": applicantName,
          "fatherOrHusbandName": fatherOrHusbandName,
          "mobileNumber": mobileNumber,
          "email": email,
          "aadhaarNumber": aadhaarNumber,
          "address": address,
          "villageName": villageName,
          "taluka": taluka,
          "district": district,
          "age": age,
          "gender": gender,
          "caste": caste,
          "annualIncome": annualIncome,
          "schemeName": schemeName,
          "purpose": purpose,
          "requiredDocuments": requiredDocuments,
          "bankAccountNumber": bankAccountNumber,
          "ifscCode": ifscCode,
          "consentAccepted": consentAccepted,
        },
      );

      debugPrint("✅ Submit Scheme Response: ${response.data}");
      return response.data;
    } on DioError catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // ✅ NEW: GET list of schemes
  Future<List<Map<String, dynamic>>> getAllSchemes() async {
    try {
      final response = await dioClient.get('/applications/schemes');
      debugPrint("✅ GET Schemes Response: ${response.data}");

      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception("Unexpected response format");
      }
    } on DioError catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  void _handleDioError(DioError e) {
    if (e.response != null) {
      debugPrint("❌ Server Error (${e.response?.statusCode}): ${e.response?.data}");
      if (e.response?.statusCode == 401) {
        throw Exception("Unauthorized. Please check your token.");
      }
      throw Exception("Server Error: ${e.response?.data}");
    } else if (e.type == DioErrorType.connectionTimeout ||
        e.type == DioErrorType.sendTimeout ||
        e.type == DioErrorType.receiveTimeout) {
      throw Exception("Request timed out. Please try again.");
    } else {
      throw Exception("Network Error: ${e.message}");
    }
  }
}
