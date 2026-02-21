import 'dart:convert';

import 'package:http/http.dart' as http;

class MedicationCreateService {
  static const String _baseUrl = 'http://10.0.2.2:8080';

  Future<bool> createMedication({
    required int userId,
    required String ilacAdi,
    required String? ilacDozu,
    required String? kullanimSikligi,
    required String? hatirlatmaSaati,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/users/$userId/medications'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ilacAdi': ilacAdi,
          'ilacDozu': ilacDozu,
          'kullanimSikligi': kullanimSikligi,
          'hatirlatmaSaati': hatirlatmaSaati,
        }),
      );
      return response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteMedication({
    required int userId,
    required int ilacId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/users/$userId/medications/$ilacId'),
        headers: const {'Content-Type': 'application/json'},
      );
      return response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }
}
