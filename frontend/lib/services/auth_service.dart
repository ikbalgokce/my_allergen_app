import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginApiResult {
  final bool success;
  final int statusCode;
  final String? code;
  final String? message;
  final int? userId;

  const LoginApiResult({
    required this.success,
    required this.statusCode,
    this.code,
    this.message,
    this.userId,
  });
}

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:8080';

  Future<LoginApiResult> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/login'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'mail': email, 'sifre': password}),
    );
    print("LOGIN status=${response.statusCode} body=${response.body}");

    Map<String, dynamic> json = {};
    if (response.body.isNotEmpty) {
      json = jsonDecode(response.body) as Map<String, dynamic>;
    }

    return LoginApiResult(
      success: (json['success'] as bool?) ?? false,
      statusCode: response.statusCode,
      code: json['code'] as String?,
      message: json['message'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
    );
  }
}
