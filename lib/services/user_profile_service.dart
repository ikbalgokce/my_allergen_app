import 'dart:convert';

import 'package:http/http.dart' as http;

class UserProfile {
  final int userId;
  final String ad;
  final String soyad;
  final String mail;
  final String sifre;
  final int yas;

  const UserProfile({
    required this.userId,
    required this.ad,
    required this.soyad,
    required this.mail,
    required this.sifre,
    required this.yas,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      ad: (json['ad'] as String?) ?? '',
      soyad: (json['soyad'] as String?) ?? '',
      mail: (json['mail'] as String?) ?? '',
      sifre: (json['sifre'] as String?) ?? '',
      yas: (json['yas'] as num?)?.toInt() ?? 0,
    );
  }

  String get fullName => '$ad $soyad'.trim();
}

class UserProfileService {
  static const String _baseUrl = 'http://10.0.2.2:8080';

  Future<UserProfile> getProfile(int userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/users/$userId/profile'),
      headers: const {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Profile fetch failed: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return UserProfile.fromJson(json);
  }

  Future<UserProfile> updateProfile({
    required int userId,
    required String ad,
    required String soyad,
    required String mail,
    required String sifre,
    required int yas,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/api/users/$userId/profile'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'ad': ad,
        'soyad': soyad,
        'mail': mail,
        'sifre': sifre,
        'yas': yas,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Profile update failed: ${response.statusCode} ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return UserProfile.fromJson(json);
  }
}
