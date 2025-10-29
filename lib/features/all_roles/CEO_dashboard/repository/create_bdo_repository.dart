import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class CreateBdoRepository {
  final DioClient dioClient;

  CreateBdoRepository({required this.dioClient});

  Future<Map<String, dynamic>> createBdo({
    required String name,
    required int ceoUserId,
  }) async {
    try {
      final response = await dioClient.post(
        '/Org/bdos',
        data: {
          "name": name,
          "ceoUserId": ceoUserId,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to create BDO: ${e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
