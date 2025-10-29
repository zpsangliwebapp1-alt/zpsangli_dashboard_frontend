import 'package:dio/dio.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/token_manager/token_manager.dart';
import '../models/additional_ceo_list_model.dart';

class AdditionalCeoListRepository {
  final DioClient dioClient;

  AdditionalCeoListRepository({required this.dioClient});

  Future<List<AdditionalCeoListModel>> getAdditionalCeoList() async {
    try {
      final token = await TokenManager.getToken();  // ✅ dynamically get token

      final response = await dioClient.get(
        AppConstants.additionalCeoEndpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': '*/*',
          },
        ),
      );

      final data = response.data;
      if (data is List) {
        return data.map((e) => AdditionalCeoListModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }
}
