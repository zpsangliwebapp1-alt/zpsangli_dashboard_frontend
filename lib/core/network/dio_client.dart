import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../storage/local_storage.dart';

class DioClient {
  final Dio dio;
  final String baseUrl;
  late final Logger _logger;
  DioClient(this.dio, {required this.baseUrl}) {
    _logger = Logger();
  }

  Future<void> init() async {
    dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      contentType: 'application/json',
    );

    dio.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        // add auth token if present
        try {
          final storage = LocalStorage(); // or get it from DI if allowed
          final token = await storage.readSecureToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } catch (e) {
          // swallow but log
        }
        return handler.next(options);
      },
    ));

    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  // convenience wrappers
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return dio.get(path, queryParameters: queryParameters);
  }
  Future<Response> post(String path, {dynamic data}) => dio.post(path, data: data);
  Future<Response> put(String path, {dynamic data}) => dio.put(path, data: data);
  Future<Response> delete(String path) => dio.delete(path);
}
