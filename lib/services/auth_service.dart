import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginApiResult {
  final bool success;
  final int statusCode;
  final String? code;
  final String? message;
  final int? userId;
  final String? ad;
  final String? soyad;

  const LoginApiResult({
    required this.success,
    required this.statusCode,
    this.code,
    this.message,
    this.userId,
    this.ad,
    this.soyad,
  });
}

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:8080';

  Future<LoginApiResult> login({
    required String mail,
    required String sifre,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/login'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'mail': mail, 'sifre': sifre}),
    );

    print('LOGIN status=${response.statusCode} body=${response.body}');

    Map<String, dynamic> json = {};
    if (response.body.isNotEmpty) {
      try {
        json = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        json = {};
      }
    }

    return LoginApiResult(
      success: (json['success'] as bool?) ?? false,
      statusCode: response.statusCode,
      code: json['code'] as String?,
      message: json['message'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      ad: json['ad'] as String?,
      soyad: json['soyad'] as String?,
    );
  }

  Future<LoginApiResult> register({
    required String ad,
    required String soyad,
    required String mail,
    required String sifre,
    required String kullaniciAd,
    required int yas,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/register'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'ad': ad,
        'soyad': soyad,
        'mail': mail,
        'sifre': sifre,
        'kullaniciAd': kullaniciAd,
        'yas': yas,
      }),
    );

    Map<String, dynamic> json = {};
    if (response.body.isNotEmpty) {
      try {
        json = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        json = {};
      }
    }

    return LoginApiResult(
      success: (json['success'] as bool?) ?? false,
      statusCode: response.statusCode,
      code: json['code'] as String?,
      message: json['message'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      ad: json['ad'] as String?,
      soyad: json['soyad'] as String?,
    );
  }
}
