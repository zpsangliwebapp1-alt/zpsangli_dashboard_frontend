import 'package:dio/dio.dart';
import '../models/ceo_json_data_model.dart';

class CeoJsonDataRepository {
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://rdprgovapi.atyoureye.com/api',
  ));

  Future<List<CeoDashboardModel>> fetchCeoData(String token) async {
    try {
      final response = await dio.get(
        '/ceo/dashboard',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((e) => CeoDashboardModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch CEO data');
      }
    } catch (e) {
      throw Exception('❌ Error fetching CEO data: $e');
    }
  }
}
