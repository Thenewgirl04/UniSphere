import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  TokenStorage._();

  static const _storage = FlutterSecureStorage();
  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';
  static const userNameKey = 'user_name';
  static const userTypeKey = 'user_type';

  static Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String name,
    required String userType,
  }) async {
    await _storage.write(key: accessTokenKey, value: accessToken);
    await _storage.write(key: refreshTokenKey, value: refreshToken);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userNameKey, name);
    await prefs.setString(userTypeKey, userType);
  }

  static Future<String?> getAccessToken() => _storage.read(key: accessTokenKey);

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  static Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userTypeKey);
  }

  static Future<void> clear() async {
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: refreshTokenKey);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userNameKey);
    await prefs.remove(userTypeKey);
  }
}
