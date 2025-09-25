import 'package:cleancity/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {
  final String baseUrl = "https://cleancity-backend-3euk.onrender.com";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final uri = Uri.parse("$baseUrl/api/auth/login");

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      String message = "Login failed: ${response.statusCode}";
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body['message'] != null) {
          message = body['message'];
        }
      } catch (_) {}
      throw Exception(message);
    }
  }
}
