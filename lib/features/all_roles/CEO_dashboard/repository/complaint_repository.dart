// lib/features/complaint/data/repositories/complaint_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/provider/auth_provider.dart';
import '../models/complaint_request_model.dart';
import '../models/complaint_response_model.dart';

class ComplaintRepository {
  final DioClient dioClient;
  final AuthProvider authProvider;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ComplaintRepository({
    required this.dioClient,
    required this.authProvider,
  });

  Future<ComplaintResponseModel> postComplaint(ComplaintRequestModel request) async {
    try {
      // ✅ Always fetch the latest token from storage
      String? token = await _storage.read(key: 'token');
      if (token == null || token.isEmpty) {
        throw Exception('No token found. Please login again.');
      }

      final response = await dioClient.post(
        'https://rdprgovapi.atyoureye.com/api/applications/complaints',
        data: request.toJson(),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('📡 POST /applications/complaints → ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      // ✅ Handle 2xx success
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        if (response.data is Map<String, dynamic>) {
          return ComplaintResponseModel.fromJson(response.data as Map<String, dynamic>);
        } else {
          throw Exception('Unexpected response format');
        }
      }

      // 🔒 Handle 401 Unauthorized — attempt token refresh once
      if (response.statusCode == 401) {
        debugPrint('⚠️ Token expired — attempting refresh...');
        final refreshed = await authProvider.refreshTokenIfNeeded();
        if (refreshed) {
          // Retry the request once after refreshing token
          final newToken = await _storage.read(key: 'token');
          final retryResponse = await dioClient.post(
            'https://rdprgovapi.atyoureye.com/api/applications/complaints',
            data: request.toJson(),
            options: Options(
              headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $newToken',
              },
            ),
          );

          if (retryResponse.statusCode != null &&
              retryResponse.statusCode! >= 200 &&
              retryResponse.statusCode! < 300) {
            return ComplaintResponseModel.fromJson(
              retryResponse.data as Map<String, dynamic>,
            );
          }
        }

        throw Exception('Unauthorized — token refresh failed');
      }

      // ⚠️ Other errors
      String errMsg = _extractErrorMessage(response);
      throw Exception(errMsg);
    } on DioException catch (e) {
      debugPrint('❌ DioException in ComplaintRepository');
      debugPrint('Message : ${e.message}');
      debugPrint('Status Code : ${e.response?.statusCode}');
      debugPrint('Data : ${e.response?.data}');
      debugPrint('Request URI : ${e.requestOptions.uri}');
      debugPrint('StackTrace : ${e.stackTrace}');

      String errMsg = 'Something went wrong. Please try again later.';
      if (e.response != null) {
        // Retry on 401 inside DioException as well
        if (e.response?.statusCode == 401) {
          final refreshed = await authProvider.refreshTokenIfNeeded();
          if (refreshed) {
            return await postComplaint(request); // Retry automatically
          }
        }
        errMsg = _extractErrorMessage(e.response!);
      }
      throw Exception(errMsg);
    } catch (e, st) {
      debugPrint('❗ Unexpected error in ComplaintRepository: $e');
      debugPrint('StackTrace: $st');
      throw Exception('Unexpected error: $e');
    }
  }
  // inside ComplaintRepository
  Future<List<dynamic>> getComplaints() async {
    try {
      // ✅ Always fetch the latest token
      String? token = await _storage.read(key: 'token');
      if (token == null || token.isEmpty) {
        throw Exception('No token found. Please login again.');
      }

      final response = await dioClient.get(
        'https://rdprgovapi.atyoureye.com/api/applications/complaints',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('📡 GET /applications/complaints → ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      // Handle 2xx success
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        if (response.data is List) {
          return response.data as List<dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }
      }

      // Handle 401 Unauthorized — attempt token refresh once
      if (response.statusCode == 401) {
        final refreshed = await authProvider.refreshTokenIfNeeded();
        if (refreshed) {
          final newToken = await _storage.read(key: 'token');
          final retryResponse = await dioClient.get(
            'https://rdprgovapi.atyoureye.com/api/applications/complaints',
            options: Options(
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer $newToken',
              },
            ),
          );

          if (retryResponse.statusCode != null &&
              retryResponse.statusCode! >= 200 &&
              retryResponse.statusCode! < 300) {
            return retryResponse.data as List<dynamic>;
          }
        }
        throw Exception('Unauthorized — token refresh failed');
      }

      throw Exception('Error ${response.statusCode}: ${response.statusMessage ?? ''}');
    } on DioException catch (e) {
      debugPrint('❌ DioException in getComplaints');
      if (e.response?.statusCode == 401) {
        final refreshed = await authProvider.refreshTokenIfNeeded();
        if (refreshed) {
          return await getComplaints(); // Retry automatically
        }
      }
      throw Exception('Something went wrong: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }


  String _extractErrorMessage(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      return data['message'].toString();
    }
    return 'Error ${response.statusCode}: ${response.statusMessage ?? ''}';
  }
}
