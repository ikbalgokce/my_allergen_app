import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/today_medications_service.dart';
import '../services/user_profile_service.dart';
import 'add_medicine_screen.dart';
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
  final Map<String, bool> _takenState = {};

  bool _isLoading = true;
  String? _loadError;
  List<TodayMedicationItem> _todayMedications = const [];
  late String _userName;
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    _userName = widget.userName;
    _userEmail = widget.userEmail;
    _loadTodayMedications();
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
        // Aldim cache'i okunamasa bile ilac listesi gosterilmeye devam etsin.
      }
      if (!mounted) return;
      setState(() {
        _todayMedications = items;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadError = 'Ilac bilgileri yuklenemedi';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_takenStorageKey);
      if (raw == null || raw.isEmpty) return;

      final savedKeys = (jsonDecode(raw) as List<dynamic>).cast<String>().toSet();
      _takenState.clear();
      for (final item in items) {
        final key = _keyOf(item);
        _takenState[key] = savedKeys.contains(key);
      }
    } catch (_) {
      // Local cache bozulduysa ilac listesini engellemesin.
      _takenState.clear();
    }
  }

  Future<void> _saveTakenStateToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final takenKeys = _takenState.entries.where((entry) => entry.value).map((entry) => entry.key).toList();
      await prefs.setString(_takenStorageKey, jsonEncode(takenKeys));
    } catch (_) {
      // Kayit basarisiz olsa bile UI akisini bozma.
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
                  const SizedBox(height: 24),
                  const Text(
                    'BUGUNKU ILACLAR',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTodayMedicationSection(),
                  const SizedBox(height: 24),
                  _buildWeeklyCard(),
                ],
              ),
            ),
          ),
        ),
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
            title: 'Ilac Ekle',
            color: Colors.blue,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddMedicineScreen()));
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
                MaterialPageRoute(builder: (_) => const AddMedicineScreen(initialMethod: 'qr')),
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
          _loadError ?? 'Bugun icin ilac kaydi bulunamadi.',
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
    final subtitle = 'Saat: ${item.hatirlatmaSaati}  |  Doz: $dose  |  Siklik: $siklik';
    final key = _keyOf(item);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: taken ? Colors.green.shade50 : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              taken ? Icons.check_circle : Icons.access_time,
              color: taken ? Colors.green.shade600 : Colors.blue.shade600,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.ilacAdi, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              setState(() {
                _takenState[key] = !taken;
              });
              await _saveTakenStateToStorage();
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: taken ? null : LinearGradient(colors: [Colors.blue.shade500, Colors.purple.shade600]),
                color: taken ? Colors.green.shade100 : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                taken ? 'Aldim (isaretli)' : 'Aldim',
                style: TextStyle(
                  color: taken ? Colors.green.shade800 : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.shade500, Colors.purple.shade600]),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(value: '-', label: 'Alinan'),
          _StatItem(value: '-', label: 'Kacirilan'),
          _StatItem(value: '-', label: 'Uyum'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
