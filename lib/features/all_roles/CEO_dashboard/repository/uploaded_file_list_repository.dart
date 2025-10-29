import 'dart:io' show File, Platform;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import '../../../../core/network/dio_client.dart';
import '../models/uploaded_file_list_model.dart';

class UploadedFileRepository {
  final DioClient dioClient;

  UploadedFileRepository({required this.dioClient});

  Future<List<UploadedFile>> getUploadedFiles({
    required int departmentId,
    required int bdoId,
    required int month,
    required int year,
    required int uploadedByUserId,
    required String token,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/files',
        queryParameters: {
          'departmentId': departmentId,
          'bdoId': bdoId,
          'month': month,
          'year': year,
          'uploadedByUserId': uploadedByUserId,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final data = response.data as List;
      return data.map((e) => UploadedFile.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }

  Future<Uint8List> downloadFileBytes({
    required String fileId,
    required String token,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/files/$fileId/download',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
        ),
      );
      return Uint8List.fromList(response.data);
    } on DioException catch (e) {
      throw Exception("Download failed: ${e.response?.data ?? e.message}");
    }
  }
}
