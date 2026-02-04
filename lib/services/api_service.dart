import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://digitalbadapatra.com/api/v1";

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<String?> _token() async {
    return _storage.read(key: "token");
  }

  static Future<Map<String, String>> _headers() async {
    final token = await _token();
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$endpoint"),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Error ${response.statusCode}: ${response.body}");
    }
  }
}
