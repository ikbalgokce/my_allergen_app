import 'dart:convert';

import 'package:http/http.dart' as http;

class MedicationCreateResult {
  final bool success;
  final int statusCode;
  final String? message;

  const MedicationCreateResult({
    required this.success,
    required this.statusCode,
    this.message,
  });
}

class MedicationCreateService {
  static const String _baseUrl = 'http://10.0.2.2:8080';

  Future<MedicationCreateResult> createMedication({
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

      String? message;
      if (response.body.isNotEmpty) {
        try {
          final json = jsonDecode(response.body) as Map<String, dynamic>;
          message = json['message'] as String?;
        } catch (_) {
          message = null;
        }
      }

      return MedicationCreateResult(
        success: response.statusCode == 201,
        statusCode: response.statusCode,
        message: message,
      );
    } catch (_) {
      return const MedicationCreateResult(success: false, statusCode: 0, message: 'NETWORK_ERROR');
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
