import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  static const _tokenKey = 'auth_token';
  final FlutterSecureStorage _secure = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // non-sensitive data
  Future<void> writeString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  String? readString(String key) => _prefs?.getString(key);

  // token (sensitive) - use secure storage
  Future<void> saveSecureToken(String token) async {
    await _secure.write(key: _tokenKey, value: token);
  }

  Future<String?> readSecureToken() => _secure.read(key: _tokenKey);

  Future<void> deleteSecureToken() => _secure.delete(key: _tokenKey);
}
