import 'package:dio/dio.dart';
import '../models/broadcast_model.dart';

class PublicBroadcastRepository {
  final Dio _dio;
  PublicBroadcastRepository(this._dio);

  Future<List<PublicBroadcastModel>> fetchActiveBroadcasts() async {
    try {
      final response = await _dio.get(
        'https://rdprgovapi.atyoureye.com/api/broadcasts/active',
        options: Options(
          headers: {
            'Authorization': 'Bearer YOUR_TOKEN_HERE',
          },
        ),
      );

      if (response.statusCode == 200 && response.data is List) {
        final List data = response.data;
        return data.map((e) => PublicBroadcastModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }
}
