import 'package:flutter/material.dart';

import '../services/drug_information_service.dart';

class DrugInformationScreen extends StatefulWidget {
  final int drugId;
  final String drugName;

  const DrugInformationScreen({
    super.key,
    required this.drugId,
    required this.drugName,
  });

  @override
  State<DrugInformationScreen> createState() => _DrugInformationScreenState();
}

class _DrugInformationScreenState extends State<DrugInformationScreen> {
  final DrugInformationService _service = DrugInformationService();
  late Future<DrugInformation> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchDrugInformation(widget.drugId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.drugName} Bilgilendirme'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5), Color(0xFFE8F5E9), Colors.white],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<DrugInformation>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Bilgilendirme verileri yuklenemedi.'),
                  ),
                );
              }

              final info = snapshot.data;
              if (info == null) {
                return const Center(child: Text('Bilgilendirme verisi bulunamadi.'));
              }

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.blue.shade500, Colors.purple.shade600]),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.22),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      '${info.ilacAdi} bilgilendirmeleri',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _infoBlock('Kisa bilgi', info.kisaBilgi),
                  _infoBlock('Uyari proaktif not', info.uyariProaktifNot),
                  _infoBlock('Sure siniri', info.sureSiniri),
                  _infoBlock('Ilac besin etkilesimi', info.ilacBesinEtkilesimi),
                  _infoBlock('Ilac yasam tarzi etkilesimi', info.ilacYasamTarziEtkilesimi),
                  _infoBlock('Uygulama sekli', info.uygulamaSekli),
                  _infoBlock('Ilac ilac cakismasi', info.ilacIlacCakismasi),
                  _infoBlock('Kullanim sikligi', info.kullanimSikligi),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _infoBlock(String title, String? value) {
    final text = (value ?? '').trim().isEmpty ? '-' : value!.trim();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.35),
          ),
        ],
      ),
    );
  }
}
