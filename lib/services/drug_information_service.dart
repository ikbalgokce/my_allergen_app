import 'dart:convert';

import 'package:http/http.dart' as http;

class DrugInformation {
  final int id;
  final String ilacAdi;
  final String? kisaBilgi;
  final String? uyariProaktifNot;
  final String? sureSiniri;
  final String? ilacBesinEtkilesimi;
  final String? ilacYasamTarziEtkilesimi;
  final String? uygulamaSekli;
  final String? ilacIlacCakismasi;
  final String? kullanimSikligi;

  const DrugInformation({
    required this.id,
    required this.ilacAdi,
    required this.kisaBilgi,
    required this.uyariProaktifNot,
    required this.sureSiniri,
    required this.ilacBesinEtkilesimi,
    required this.ilacYasamTarziEtkilesimi,
    required this.uygulamaSekli,
    required this.ilacIlacCakismasi,
    required this.kullanimSikligi,
  });

  factory DrugInformation.fromJson(Map<String, dynamic> json) {
    return DrugInformation(
      id: (json['id'] as num?)?.toInt() ?? 0,
      ilacAdi: (json['ilacAdi'] as String?) ?? 'Bilinmeyen ilac',
      kisaBilgi: json['kisaBilgi'] as String?,
      uyariProaktifNot: json['uyariProaktifNot'] as String?,
      sureSiniri: json['sureSiniri'] as String?,
      ilacBesinEtkilesimi: json['ilacBesinEtkilesimi'] as String?,
      ilacYasamTarziEtkilesimi: json['ilacYasamTarziEtkilesimi'] as String?,
      uygulamaSekli: json['uygulamaSekli'] as String?,
      ilacIlacCakismasi: json['ilacIlacCakismasi'] as String?,
      kullanimSikligi: json['kullanimSikligi'] as String?,
    );
  }
}

class DrugInformationService {
  static const String _baseUrl = 'http://10.0.2.2:8080';

  Future<DrugInformation> fetchDrugInformation(int drugId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/drugs/$drugId/information'),
      headers: const {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Ilac bilgilendirme verisi alinamadi');
    }

    final body = response.body.trim();
    if (body.isEmpty) {
      throw Exception('Ilac bilgilendirme verisi bos geldi');
    }

    final json = jsonDecode(body) as Map<String, dynamic>;
    return DrugInformation.fromJson(json);
  }
}
