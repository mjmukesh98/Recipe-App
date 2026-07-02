import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  static const String tokenKey = "token";
  static const String refreshTokenKey = "refresh_token";

  // ACCESS TOKEN
  static Future<void> saveToken(String token) async {
    await storage.write(key: tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await storage.read(key: tokenKey);
  }

  // REFRESH TOKEN
  static Future<void> saveRefreshToken(String token) async {
    await storage.write(key: refreshTokenKey, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await storage.read(key: refreshTokenKey);
  }

  static Future<void> deleteToken() async {
    await storage.delete(key: tokenKey);
  }

  static Future<void> clearAll() async {
    await storage.deleteAll();
  }
}
