import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/registration_request.dart';
import '../models/registration_response.dart';

class RegistrationRepository {
  final DioClient dioClient;

  RegistrationRepository({required this.dioClient});

  Future<RegistrationResponse> registerUser({
    required RegistrationRequest request,
    required String token,
  }) async {
    try {
      final response = await dioClient.post(
        '/Auth/register',
        data: request.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return RegistrationResponse.fromJson(response.data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
