import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/brodcaste_model.dart';


class BroadcastRepository {
  final DioClient dioClient;

  BroadcastRepository({required this.dioClient});

  /// Text + Image
  Future<Broadcast> sendTextImage({
    Uint8List? imageBytes,
    String? imageName,
    File? imageFile,
    required String messageText,
    required String expiresAt,
    required String token,
  }) async {
    final formData = FormData.fromMap({
      'image': imageBytes != null
          ? MultipartFile.fromBytes(imageBytes, filename: imageName)
          : await MultipartFile.fromFile(imageFile!.path,
          filename: imageFile.path.split('/').last),
      'messageText': messageText,
      'expiresAt': expiresAt,
    });

    final response = await dioClient.dio.post(
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
  }

  /// Text + URL
  Future<Broadcast> sendTextLink({
    required String messageText,
    required String linkUrl,
    required String expiresAt,
    required String token,
  }) async {
    final formData = FormData.fromMap({
      'messageText': messageText,
      'linkUrl': linkUrl,
      'expiresAt': expiresAt,
    });

    final response = await dioClient.dio.post(
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
  }
}
