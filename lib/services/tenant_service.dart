import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TenantService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveBaseUrl(String baseUrl) async {
    await _storage.write(key: "base_url", value: baseUrl);
  }

  static Future<String?> getBaseUrl() async {
    return _storage.read(key: "base_url");
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}