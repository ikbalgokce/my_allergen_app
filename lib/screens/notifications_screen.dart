import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_item.dart';
import '../services/allergen_service.dart';
import '../services/notification_settings_service.dart';
import '../services/risk_warning_service.dart';
import '../services/today_medications_service.dart';

class NotificationsScreen extends StatefulWidget {
  final int userId;

  const NotificationsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final TodayMedicationsService _todayMedicationsService = TodayMedicationsService();
  final RiskWarningService _riskWarningService = RiskWarningService();
  final AllergenService _allergenService = AllergenService();
  final NotificationSettingsService _settingsService = NotificationSettingsService();

  String selectedFilter = 'Tümü';
  bool _isLoading = true;
  List<NotificationItem> allNotifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);

    try {
      final meds = await _todayMedicationsService.fetchTodayMedications(widget.userId);
      final warning = await _riskWarningService.getRiskWarning(widget.userId);
      final allergens = await _allergenService.getAllergens(widget.userId);
      final reminderBefore = await _settingsService.getReminderBeforeMinutes(widget.userId);
      final takenSet = await _loadTakenSet();

      int idCounter = 1;
      final List<NotificationItem> generated = [];
      final now = DateTime.now();

      for (final item in meds) {
        final key = '${item.ilacId}_${item.hatirlatmaSaati}';
        final isTaken = takenSet.contains(key);
        final scheduled = _parseTodayTime(item.hatirlatmaSaati);

        if (isTaken) {
          generated.add(
            NotificationItem(
              id: idCounter++,
              type: 'ilac',
              title: 'İlaç alındı',
              message: '${item.ilacAdi} ilacı alındı olarak işaretlendi.',
              time: 'Bugün ${item.hatirlatmaSaati}',
              isRead: true,
              priority: 'low',
            ),
          );
          continue;
        }

        if (scheduled == null) {
          generated.add(
            NotificationItem(
              id: idCounter++,
              type: 'ilac',
              title: 'İlaç hatırlatması',
              message: '${item.ilacAdi} ilacının saati okunamadı.',
              time: item.hatirlatmaSaati,
              isRead: false,
              priority: 'medium',
            ),
          );
          continue;
        }

        final diff = scheduled.difference(now).inMinutes;

        if (diff < 0) {
          generated.add(
            NotificationItem(
              id: idCounter++,
              type: 'ilac',
              title: 'İlaç saati geçti',
              message: '${item.ilacAdi} ilacı için ${diff.abs()} dakika gecikme var.',
              time: 'Bugün ${item.hatirlatmaSaati}',
              isRead: false,
              priority: 'high',
            ),
          );
        } else if (diff <= reminderBefore) {
          generated.add(
            NotificationItem(
              id: idCounter++,
              type: 'ilac',
              title: 'İlaç hatırlatması',
              message: '${item.ilacAdi} ilacını kullanmana $diff dakika kaldı.',
              time: 'Bugün ${item.hatirlatmaSaati}',
              isRead: false,
              priority: diff <= 5 ? 'high' : 'medium',
            ),
          );
        } else {
          final untilReminder = diff - reminderBefore;
          generated.add(
            NotificationItem(
              id: idCounter++,
              type: 'ilac',
              title: 'Planlı ilaç bildirimi',
              message:
                  '${item.ilacAdi} ilacı için bildirim $untilReminder dakika sonra gönderilecek (ilaç saatine $diff dakika var).',
              time: 'Bugün ${item.hatirlatmaSaati}',
              isRead: true,
              priority: 'low',
            ),
          );
        }
      }

      if (allergens.isNotEmpty) {
        generated.add(
          NotificationItem(
            id: idCounter++,
            type: 'alerji',
            title: 'Alerjen profili güncel',
            message: 'Kayıtlı alerjenler: ${allergens.join(', ')}',
            time: 'Bugün',
            isRead: false,
            priority: 'medium',
          ),
        );
      }

      if (warning.risk) {
        final details = warning.matchedItems.isEmpty ? '' : ' Eslesenler: ${warning.matchedItems.join(', ')}';
        generated.add(
          NotificationItem(
            id: idCounter++,
            type: 'alerji',
            title: 'Alerji uyarısı',
            message: '${warning.message}$details',
            time: 'Bugün',
            isRead: false,
            priority: 'high',
          ),
        );
      }

      if (!mounted) return;
      setState(() => allNotifications = generated);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<Set<String>> _loadTakenSet() async {
    final now = DateTime.now();
    final mm = now.month.toString().padLeft(2, '0');
    final dd = now.day.toString().padLeft(2, '0');
    final dateKey = '${now.year}-$mm-$dd';
    final storageKey = 'taken_${widget.userId}_$dateKey';

    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(storageKey);
      if (raw == null || raw.isEmpty) return {};
      return (jsonDecode(raw) as List<dynamic>).cast<String>().toSet();
    } catch (_) {
      return {};
    }
  }

  DateTime? _parseTodayTime(String value) {
    final parts = value.split(':');
    if (parts.length < 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  List<NotificationItem> get filteredNotifications {
    if (selectedFilter == 'Tümü') return allNotifications;
    final filterType = selectedFilter == 'İlaç' ? 'ilac' : 'alerji';
    return allNotifications.where((n) => n.type == filterType).toList();
  }

  int get unreadCount => allNotifications.where((n) => !n.isRead).length;

  void _markAsRead(int id) {
    setState(() {
      allNotifications.firstWhere((n) => n.id == id).isRead = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (final notification in allNotifications) {
        notification.isRead = true;
      }
    });
  }

  void _deleteNotification(int id) {
    setState(() {
      allNotifications.removeWhere((n) => n.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFE5E5),
            Color(0xFFFFE8CC),
            Color(0xFFFFF4E0),
            Color(0xFFE8F8F5),
          ],
          stops: [0.0, 0.35, 0.65, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bildirimler',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$unreadCount okunmamış bildirim',
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: _loadNotifications,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.refresh, size: 16),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (unreadCount > 0)
                            InkWell(
                              onTap: _markAllAsRead,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Colors.blue.shade500, Colors.purple.shade600]),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Tümü Okundu',
                                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['Tümü', 'İlaç', 'Alerji'].map((filter) {
                        final isSelected = selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () => setState(() => selectedFilter = filter),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(colors: [Colors.blue.shade500, Colors.purple.shade600])
                                    : null,
                                color: isSelected ? null : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey.shade700,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredNotifications.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey.shade400),
                              const SizedBox(height: 16),
                              Text(
                                'Bildirim Yok',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = filteredNotifications[index];
                            return _buildNotificationCard(notification);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    Color getTypeColor() {
      switch (notification.type) {
        case 'alerji':
          return Colors.red.shade500;
        case 'ilac':
          return Colors.blue.shade500;
        default:
          return Colors.grey.shade500;
      }
    }

    IconData getTypeIcon() {
      switch (notification.type) {
        case 'alerji':
          return Icons.warning_amber_rounded;
        case 'ilac':
          return Icons.medication;
        default:
          return Icons.notifications;
      }
    }

    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteNotification(notification.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: BorderRadius.circular(16)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      child: InkWell(
        onTap: () {
          if (!notification.isRead) {
            _markAsRead(notification.id);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
            border: notification.isRead ? null : Border.all(color: Colors.blue.shade200, width: 2),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: getTypeColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(getTypeIcon(), color: getTypeColor(), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(color: Colors.blue.shade600, shape: BoxShape.circle),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.message,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(notification.time, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                          const Spacer(),
                          if (notification.priority == 'high')
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                'Acil',
                                style: TextStyle(fontSize: 10, color: Colors.red.shade700, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
