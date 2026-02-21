import 'dart:convert';

import 'package:http/http.dart' as http;

class TodayMedicationItem {
  final int ilacId;
  final String ilacAdi;
  final String? ilacDozu;
  final String? kullanimSikligi;
  final String hatirlatmaSaati;
  final String? baslangicTarihi;
  final String? bitisTarihi;
  final String? sureSiniri;

  const TodayMedicationItem({
    required this.ilacId,
    required this.ilacAdi,
    required this.ilacDozu,
    required this.kullanimSikligi,
    required this.hatirlatmaSaati,
    required this.baslangicTarihi,
    required this.bitisTarihi,
    required this.sureSiniri,
  });

  factory TodayMedicationItem.fromJson(Map<String, dynamic> json) {
    return TodayMedicationItem(
      ilacId: (json['ilacId'] as num?)?.toInt() ?? 0,
      ilacAdi: (json['ilacAdi'] as String?) ?? 'Bilinmeyen ilac',
      ilacDozu: json['ilacDozu'] as String?,
      kullanimSikligi: json['kullanimSikligi'] as String?,
      hatirlatmaSaati: (json['hatirlatmaSaati'] as String?) ?? '-',
      baslangicTarihi: json['baslangicTarihi'] as String?,
      bitisTarihi: json['bitisTarihi'] as String?,
      sureSiniri: json['sureSiniri'] as String?,
    );
  }
}

class TodayMedicationsService {
  static const String _baseUrl = 'http://10.0.2.2:8080';

  Future<List<TodayMedicationItem>> fetchTodayMedications(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/users/$userId/today-medications'),
        headers: const {'Content-Type': 'application/json'},
      );
      print('TODAY_MEDS status=${response.statusCode} body=${response.body}');

      if (response.statusCode != 200) {
        return const [];
      }

      final body = response.body.trim();
      if (body.isEmpty) return const [];

      final list = jsonDecode(body) as List<dynamic>;
      return list
          .map((e) => TodayMedicationItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
