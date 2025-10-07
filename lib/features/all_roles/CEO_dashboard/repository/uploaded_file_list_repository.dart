// repository/uploaded_file_repository.dart
import 'package:dio/dio.dart';
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
    } catch (e) {
      if (e is DioError) {
        throw Exception(e.response?.data ?? e.message);
      } else {
        throw Exception(e.toString());
      }
    }
  }
}
