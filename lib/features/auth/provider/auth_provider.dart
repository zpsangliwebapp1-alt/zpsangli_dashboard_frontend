import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthProvider(this.repository);

  bool _loading = false;
  bool get loading => _loading;

  int? _roleId;
  int? get roleId => _roleId;

  int? _userId;
  int? get userId => _userId;

  String? _token;
  String? _refreshToken;
  String? get token => _token;

  String? _email;
  String? get email => _email;


  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  /// ---------------- LOGIN ----------------
  Future<bool> login(String username, String password) async {
    _loading = true;
    notifyListeners();
    try {
      final data = await repository.login(username, password);

      _token = data['token'];
      _refreshToken = data['refreshToken'];
      _roleId = data['roleId'];
      _userId = data['userId'];
      _email = data['email'] ?? username;

      await _saveToStorage();

      _loading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> tryAutoLogin() async {
    _token = await _storage.read(key: 'token');
    _refreshToken = await _storage.read(key: 'refreshToken');
    final roleIdStr = await _storage.read(key: 'roleId');
    _roleId = roleIdStr != null ? int.tryParse(roleIdStr) : null;
    _email = await _storage.read(key: 'email');

    final userIdStr = await _storage.read(key: 'userId');
    _userId = userIdStr != null ? int.tryParse(userIdStr) : null;

    notifyListeners();
    return isAuthenticated;
  }

  /// ---------------- LOGOUT ----------------
  Future<void> logout() async {
    _token = null;
    _refreshToken = null;
    _roleId = null;
    _email = null;
    _userId = null;

    await _storage.deleteAll();
    notifyListeners();
  }

  /// ---------------- SAVE TO STORAGE ----------------
  Future<void> _saveToStorage() async {
    if (_token != null) await _storage.write(key: 'token', value: _token);
    if (_refreshToken != null) await _storage.write(key: 'refreshToken', value: _refreshToken);
    if (_roleId != null) await _storage.write(key: 'roleId', value: _roleId.toString());
    if (_email != null) await _storage.write(key: 'email', value: _email);
    if (_userId != null) await _storage.write(key: 'userId', value: _userId.toString());
  }

  /// ---------------- REFRESH TOKEN ----------------
  Future<bool> refreshTokenIfNeeded() async {
    if (_refreshToken == null || _refreshToken!.isEmpty) return false;

    try {
      final url = Uri.parse('https://rdprgovapi.atyoureye.com/api/auth/refresh');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"refreshToken": _refreshToken}),
      );

      if (response.statusCode != 200) {
        debugPrint("❌ Failed to refresh token: ${response.statusCode}");
        return false;
      }

      final data = json.decode(response.body);
      _token = data['token'];
      _refreshToken = data['refreshToken'] ?? _refreshToken;

      // Update roleId and email if returned
      _roleId = data['roleId'] ?? _roleId;
      _email = data['username'] ?? _email;

      await _saveToStorage();
      notifyListeners();

      debugPrint("✅ Token refreshed successfully");
      return true;
    } catch (e) {
      debugPrint("❌ Exception while refreshing token: $e");
      return false;
    }
  }
}
