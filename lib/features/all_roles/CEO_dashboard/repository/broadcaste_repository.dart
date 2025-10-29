import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/broadcast_model.dart';
import '../models/brodcaste_model.dart';

class BroadcastRepository {
  final DioClient dioClient;

  BroadcastRepository({required this.dioClient});

  Future<Broadcast> sendTextImage({
    Uint8List? imageBytes,
    String? imageName,
    File? imageFile,
    required String messageText,
    required String expiresAt,
    // required String category, // ✅ NEW
    required String token,
  }) async {
    try {
      final formData = FormData.fromMap({
        'image': imageBytes != null
            ? MultipartFile.fromBytes(imageBytes, filename: imageName)
            : await MultipartFile.fromFile(
          imageFile!.path,
          filename: imageFile.path.split('/').last,
        ),
        'messageText': messageText,
        'expiresAt': expiresAt,
        // 'category': category, // ✅ Include category dynamically
      });

      final response = await dioClient.post(
        '/broadcasts/text-image',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return Broadcast.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to send broadcast');
    } catch (e) {
      throw Exception('Failed to send broadcast: $e');
    }
  }


  Future<Broadcast> sendTextLink({
    required String messageText,
    required String linkUrl,
    required String expiresAt,
    // required String category, // ✅ NEW
    required String token,
  }) async {
    try {
      final formData = FormData.fromMap({
        'messageText': messageText,
        'linkUrl': linkUrl,
        'expiresAt': expiresAt,
        // 'category': category, // ✅ Include category
      });

      final response = await dioClient.post(
        '/broadcasts/text-link',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return Broadcast.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to send broadcast');
    } catch (e) {
      throw Exception('Failed to send broadcast: $e');
    }
  }
  Future<List<BroadcastModel>> fetchActiveBroadcasts() async {
    try {
      final response = await dioClient.get('/broadcasts/active');
      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((e) => BroadcastModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load broadcasts");
      }
    } on DioException catch (e) {
      print("**************");
      print(e.response?.data.toString());
      throw Exception(e.response?.data ?? "Network error");
      
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
