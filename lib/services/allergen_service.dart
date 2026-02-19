import 'dart:convert';

import 'package:http/http.dart' as http;

class AllergenService {
  static const String _baseUrl = 'http://10.0.2.2:8080';

  Future<List<String>> getAllergens(int userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/users/$userId/allergens'),
      headers: const {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) return const [];
    final body = response.body.trim();
    if (body.isEmpty) return const [];

    final json = jsonDecode(body) as Map<String, dynamic>;
    final raw = (json['allergens'] as List<dynamic>?) ?? const [];
    return raw.map((e) => e.toString()).toList();
  }

  Future<List<String>> removeAllergen({
    required int userId,
    required String allergenName,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/users/$userId/allergens')
        .replace(queryParameters: {'name': allergenName});

    final response = await http.delete(
      uri,
      headers: const {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) return const [];
    final body = response.body.trim();
    if (body.isEmpty) return const [];

    final json = jsonDecode(body) as Map<String, dynamic>;
    final raw = (json['allergens'] as List<dynamic>?) ?? const [];
    return raw.map((e) => e.toString()).toList();
  }

  Future<List<String>> addAllergen({
    required int userId,
    required String allergenName,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/users/$userId/allergens'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'name': allergenName}),
    );

    if (response.statusCode != 200) return const [];
    final body = response.body.trim();
    if (body.isEmpty) return const [];

    final json = jsonDecode(body) as Map<String, dynamic>;
    final raw = (json['allergens'] as List<dynamic>?) ?? const [];
    return raw.map((e) => e.toString()).toList();
  }
}
