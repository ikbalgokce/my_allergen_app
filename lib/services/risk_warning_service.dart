import 'dart:convert';

import 'package:http/http.dart' as http;

class RiskWarningResult {
  final bool risk;
  final String message;
  final List<String> matchedItems;

  const RiskWarningResult({
    required this.risk,
    required this.message,
    required this.matchedItems,
  });
}

class RiskWarningService {
  static const String _baseUrl = 'http://10.0.2.2:8080';

  Future<RiskWarningResult> getRiskWarning(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/users/$userId/risk-warning'),
        headers: const {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200) {
        return const RiskWarningResult(risk: false, message: '', matchedItems: []);
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final items = ((json['matchedItems'] as List<dynamic>?) ?? const [])
          .map((e) => e.toString())
          .toList();

      return RiskWarningResult(
        risk: (json['risk'] as bool?) ?? false,
        message: (json['message'] as String?) ?? '',
        matchedItems: items,
      );
    } catch (_) {
      return const RiskWarningResult(risk: false, message: '', matchedItems: []);
    }
  }
}
