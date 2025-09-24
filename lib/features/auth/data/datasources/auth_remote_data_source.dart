import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;
  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await dioClient.post('/api/login', data: {'email': email, 'password': password});
    return res.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> register(String email, String password) async {
    final res = await dioClient.post('/api/register', data: {'email': email, 'password': password});
    return res.data as Map<String, dynamic>;
  }
}
