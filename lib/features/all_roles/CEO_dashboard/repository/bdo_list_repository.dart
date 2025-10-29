import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/provider/auth_provider.dart';

class BdoListRepository {
  final DioClient dioClient;
  final AuthProvider authProvider;

  BdoListRepository({
    required this.dioClient,
    required this.authProvider,
  });

  Future<List<Map<String, dynamic>>> fetchBdos() async {
    try {
      final token = authProvider.token;
      final ceoId = authProvider.userId ?? 2; // fallback
      if (token == null || token.isEmpty) {
        throw Exception('Auth token not available');
      }

      final response = await dioClient.get(
        '/Org/bdos?parent_ceo_id=2',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': '*/*',
          },
        ),
      );

      // ✅ Debug log raw response
      debugPrint('🔹 Raw BDO Response: ${response.data}');
      print("******************");
      debugPrint('🔹 token: ${token}');


      if (response.data is List) {
        final data = response.data as List;

        // ✅ Pretty print each BDO entry
        for (var i = 0; i < data.length; i++) {
          final item = Map<String, dynamic>.from(data[i]);
          debugPrint('🟩 BDO #${i + 1}:');
          item.forEach((key, value) {
            debugPrint('   $key: $value');
          });
          debugPrint('-----------------------------');
        }

        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        debugPrint('⚠️ Unexpected data format: ${response.data.runtimeType}');
        return [];
      }
    } catch (e, st) {
      debugPrint('❌ Error fetching BDOs: $e');
      debugPrint('🧾 StackTrace: $st');
      rethrow;
    }
  }
}
