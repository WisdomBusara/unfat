import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _accessKey = 'kaza_access_token';
  static const _refreshKey = 'kaza_refresh_token';
  static const _userIdKey = 'kaza_user_id';

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) async {
    await Future.wait([
      _storage.write(key: _accessKey, value: accessToken),
      _storage.write(key: _refreshKey, value: refreshToken),
      _storage.write(key: _userIdKey, value: userId),
    ]);
  }

  static Future<String?> get accessToken => _storage.read(key: _accessKey);
  static Future<String?> get refreshToken => _storage.read(key: _refreshKey);
  static Future<String?> get userId => _storage.read(key: _userIdKey);

  static Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _accessKey),
      _storage.delete(key: _refreshKey),
      _storage.delete(key: _userIdKey),
    ]);
  }
}
