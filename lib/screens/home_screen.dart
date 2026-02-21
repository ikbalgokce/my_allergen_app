import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/risk_warning_service.dart';
import '../services/medication_create_service.dart';
import '../services/today_medications_service.dart';
import '../services/user_profile_service.dart';
import 'add_medicine_screen.dart';
import 'drug_information_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  final String userName;
  final String userEmail;

  const HomeScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodayMedicationsService _todayMedicationsService = TodayMedicationsService();
  final MedicationCreateService _medicationCreateService = MedicationCreateService();
  final RiskWarningService _riskWarningService = RiskWarningService();
  final Map<String, bool> _takenState = {};

  bool _isLoading = true;
  String? _loadError;
  List<TodayMedicationItem> _todayMedications = const [];
  RiskWarningResult _riskWarning = const RiskWarningResult(risk: false, message: '', matchedItems: []);
  late String _userName;
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    _userName = widget.userName;
    _userEmail = widget.userEmail;
    _loadTodayMedications();
    _loadRiskWarning();
  }

  Future<void> _loadTodayMedications() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final items = await _todayMedicationsService.fetchTodayMedications(widget.userId);
      try {
        await _loadTakenStateFromStorage(items);
      } catch (_) {
        // Aldım cache'i okunamasa bile liste gösterilsin.
      }

      if (!mounted) return;
      setState(() {
        _todayMedications = items;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadError = 'İlaç bilgileri yüklenemedi';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadRiskWarning() async {
    final warning = await _riskWarningService.getRiskWarning(widget.userId);
    if (!mounted) return;
    setState(() => _riskWarning = warning);
  }

  String _keyOf(TodayMedicationItem item) => '${item.ilacId}_${item.hatirlatmaSaati}';

  String get _dateKey {
    final now = DateTime.now();
    final mm = now.month.toString().padLeft(2, '0');
    final dd = now.day.toString().padLeft(2, '0');
    return '${now.year}-$mm-$dd';
  }

  String get _takenStorageKey => 'taken_${widget.userId}_$_dateKey';

  Future<void> _loadTakenStateFromStorage(List<TodayMedicationItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_takenStorageKey);
    if (raw == null || raw.isEmpty) return;

    final savedKeys = (jsonDecode(raw) as List<dynamic>).cast<String>().toSet();
    _takenState.clear();
    for (final item in items) {
      final key = _keyOf(item);
      _takenState[key] = savedKeys.contains(key);
    }
  }

  Future<void> _saveTakenStateToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final takenKeys = _takenState.entries.where((entry) => entry.value).map((entry) => entry.key).toList();
      await prefs.setString(_takenStorageKey, jsonEncode(takenKeys));
    } catch (_) {
      // Kayıt başarısız olsa bile UI akışını bozma.
    }
  }

  Future<void> _openProfile() async {
    final result = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(builder: (_) => ProfileScreen(userId: widget.userId)),
    );
    if (result == null || !mounted) return;

    setState(() {
      _userName = result.fullName.isNotEmpty ? result.fullName : _userName;
      _userEmail = result.mail;
    });
  }

  Future<void> _confirmDeleteMedication(TodayMedicationItem item) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('İlacı Çıkart'),
        content: Text('${item.ilacAdi} ilacını çıkartmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600),
            child: const Text('Evet', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result != true) return;

    final ok = await _medicationCreateService.deleteMedication(
      userId: widget.userId,
      ilacId: item.ilacId,
    );

    if (!mounted) return;

    if (ok) {
      final key = _keyOf(item);
      setState(() {
        _todayMedications = _todayMedications.where((m) => m.ilacId != item.ilacId).toList();
        _takenState.remove(key);
      });
      await _saveTakenStateToStorage();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('İlaç listeden çıkarıldı'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('İlaç çıkarılamadı'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5), Color(0xFFE8F5E9), Colors.white],
          stops: [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadTodayMedications,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildQuickActions(context),
                  if (_riskWarning.risk) ...[
                    const SizedBox(height: 16),
                    _buildRiskWarningBox(),
                  ],
                  const SizedBox(height: 24),
                  const Text(
                    'İLAÇLAR',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTodayMedicationSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRiskWarningBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade300, width: 1.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '!!! ${_riskWarning.message}',
                  style: TextStyle(
                    color: Colors.red.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          if (_riskWarning.matchedItems.isNotEmpty) ...[
            const SizedBox(height: 8),
            ..._riskWarning.matchedItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '- $item',
                  style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Merhaba $_userName!',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(_userEmail, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          ],
        ),
        InkWell(
          onTap: _openProfile,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue.shade500, Colors.purple.shade600]),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            context,
            icon: Icons.add_circle,
            title: 'İlaç Ekle',
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddMedicineScreen(userId: widget.userId)),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            context,
            icon: Icons.qr_code_scanner,
            title: 'QR Tara',
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddMedicineScreen(userId: widget.userId, initialMethod: 'qr'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTodayMedicationSection() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_todayMedications.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Text(
          _loadError ?? 'Bugün için ilaç kaydı bulunamadı.',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      );
    }

    return Column(
      children: _todayMedications.map((item) {
        final key = _keyOf(item);
        final taken = _takenState[key] ?? false;
        return _buildMedicineCard(item: item, taken: taken);
      }).toList(),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineCard({
    required TodayMedicationItem item,
    required bool taken,
  }) {
    final dose = (item.ilacDozu ?? '').trim().isEmpty ? '-' : item.ilacDozu!;
    final siklik = (item.kullanimSikligi ?? '').trim().isEmpty ? '-' : item.kullanimSikligi!;
    final baslangic = (item.baslangicTarihi ?? '').trim().isEmpty ? '-' : item.baslangicTarihi!;
    final bitis = (item.bitisTarihi ?? '').trim().isEmpty ? '-' : item.bitisTarihi!;
    final sureSiniri = (item.sureSiniri ?? '').trim();

    final ilacAdi = _formatDrugTitle(item.ilacAdi, bitis, sureSiniri);
    final subtitle = 'Saat: ${item.hatirlatmaSaati}  |  Doz: $dose  |  Sıklık: $siklik';
    final key = _keyOf(item);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: taken ? Colors.green.shade50 : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  taken ? Icons.check_circle : Icons.access_time,
                  color: taken ? Colors.green.shade600 : Colors.blue.shade600,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ilacAdi,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 28 / 1.75, fontWeight: FontWeight.bold),
                          ),
                        ),
                        InkWell(
                          onTap: () => _confirmDeleteMedication(item),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Icon(Icons.close, size: 17, color: Colors.red.shade600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Text(
                        'Başlangıç Tarihi: $baslangic',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.deepOrange.shade200),
                      ),
                      child: Text(
                        'Bitiş Tarihi: $bitis',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.deepOrange.shade900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      _takenState[key] = !taken;
                    });
                    await _saveTakenStateToStorage();
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: taken ? null : LinearGradient(colors: [Colors.blue.shade500, Colors.purple.shade600]),
                      color: taken ? Colors.green.shade100 : null,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      taken ? 'Aldım (işaretli)' : 'Aldım',
                      style: TextStyle(
                        color: taken ? Colors.green.shade900 : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DrugInformationScreen(
                          drugId: item.ilacId,
                          drugName: item.ilacAdi,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.purple.shade500]),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.18),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Bilgilendirme',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDrugTitle(String ilacAdi, String bitisTarihi, String sureSiniri) {
    if (bitisTarihi != '-') return ilacAdi;
    if (sureSiniri.isEmpty) return ilacAdi;
    return '$ilacAdi ($sureSiniri)';
  }
}
