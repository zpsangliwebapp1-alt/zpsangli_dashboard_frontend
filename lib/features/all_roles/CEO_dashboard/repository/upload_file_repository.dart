import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/upload_file_model.dart';

class UploadFileRepository {
  final DioClient dioClient;

  UploadFileRepository({required this.dioClient});

  Future<UploadFileResponse> uploadExcelFile({
    required Uint8List fileBytes,
    required String fileName,
    required int departmentId,
    required int bdoId,
    required int month,
    required int year,
    required String token,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
        'departmentId': departmentId.toString(),
        'bdoId': bdoId.toString(),
        'month': month.toString(),
        'year': year.toString(),
      });

      final response = await dioClient.dio.post(
        '/files/excel',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      return UploadFileResponse.fromJson(response.data);
    } catch (e) {
      if (e is DioError) {
        throw Exception(e.response?.data ?? e.message);
      } else {
        throw Exception(e.toString());
      }
    }
  }
}
