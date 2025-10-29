import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/auth/provider/auth_provider.dart';
import '../constants/app_strings.dart';

class DioClient {

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'accept': '*/*'},
    ),
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AuthProvider? authProvider; // optional injection
  String? _token;

  DioClient({this.authProvider}) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioError e, ErrorInterceptorHandler handler) async {
          if (e.response?.statusCode == 401 && authProvider != null) {
            // Attempt token refresh
            final refreshed = await authProvider!.refreshTokenIfNeeded();
            if (refreshed) {
              _token = authProvider!.token;
              _dio.options.headers['Authorization'] = 'Bearer $_token';

              // Retry the original request
              final cloneReq = await _dio.request(
                e.requestOptions.path,
                data: e.requestOptions.data,
                queryParameters: e.requestOptions.queryParameters,
                options: Options(
                  method: e.requestOptions.method,
                ),
              );
              return handler.resolve(cloneReq);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }


  Dio get dio => _dio;

  /// ---------------- INITIALIZE TOKEN ----------------
  /// Reads token either from AuthProvider or secure storage
  Future<void> initToken() async {
    try {
      // 1️⃣ Prefer AuthProvider token if injected
      if (authProvider != null && authProvider!.token != null) {
        _token = authProvider!.token;
      } else {
        // 2️⃣ Otherwise load from FlutterSecureStorage
        _token = await _storage.read(key: 'token');
      }

      if (_token != null && _token!.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $_token';
        if (kDebugMode) print("🔐 Token initialized successfully");
      } else {
        if (kDebugMode) print("⚠️ No token found, proceeding unauthenticated");
      }
    } catch (e) {
      if (kDebugMode) print("❌ Error initializing token: $e");
    }
  }



  /// ---------------- MANUALLY SET TOKEN ----------------
  void setToken(String token) {
    _token = token;
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// ---------------- GET REQUEST ----------------
  Future<Response> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    await _ensureToken();
    if (kDebugMode) {
      print("➡️ GET $endpoint params: $queryParameters headers: ${_dio.options.headers}");
    }
    return await _dio.get(endpoint, queryParameters: queryParameters, options: options);
  }

  /// ---------------- POST REQUEST ----------------
  Future<Response> post(
      String endpoint, {
        dynamic data,
        Options? options,
      }) async {
    await _ensureToken();
    if (kDebugMode) {
      print("➡️ POST $endpoint data: $data headers: ${_dio.options.headers}");
    }
    return await _dio.post(endpoint, data: data, options: options);
  }

  /// ---------------- PRIVATE: ENSURE TOKEN ----------------
  Future<void> _ensureToken() async {
    if (_token == null || _token!.isEmpty) {
      await initToken();
    }

    // Double-check that token is in header
    if (_token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $_token';
    }
  }
}
