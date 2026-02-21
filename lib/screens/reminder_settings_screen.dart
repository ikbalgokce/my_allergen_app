import 'package:flutter/material.dart';

import '../services/notification_settings_service.dart';

class ReminderSettingsScreen extends StatefulWidget {
  final int userId;

  const ReminderSettingsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ReminderSettingsScreen> createState() => _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends State<ReminderSettingsScreen> {
  final NotificationSettingsService _settingsService = NotificationSettingsService();

  bool notificationsEnabled = true;
  bool soundEnabled = true;
  bool vibrationEnabled = true;
  bool persistentNotification = false;
  int reminderBefore = 15;
  String notificationSound = 'Varsayılan';

  @override
  void initState() {
    super.initState();
    _loadReminderBefore();
  }

  Future<void> _loadReminderBefore() async {
    final value = await _settingsService.getReminderBeforeMinutes(widget.userId);
    if (!mounted) return;
    setState(() => reminderBefore = value);
  }

  Future<void> _saveReminderBefore(int value) async {
    await _settingsService.setReminderBeforeMinutes(
      userId: widget.userId,
      minutes: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hatırlatma Ayarları',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        Text(
                          'Bildirim tercihlerinizi yönetin',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSwitchCard(
                        icon: Icons.notifications,
                        title: 'Bildirimleri Etkinleştir',
                        subtitle: 'Tüm ilaç hatırlatmalarını aç/kapa',
                        value: notificationsEnabled,
                        onChanged: (value) => setState(() => notificationsEnabled = value),
                      ),
                      _buildSwitchCard(
                        icon: Icons.volume_up,
                        title: 'Bildirim Sesi',
                        subtitle: 'Hatırlatmalarda ses çal',
                        value: soundEnabled,
                        enabled: notificationsEnabled,
                        onChanged: (value) => setState(() => soundEnabled = value),
                      ),
                      _buildSwitchCard(
                        icon: Icons.vibration,
                        title: 'Titreşim',
                        subtitle: 'Bildirimde telefon titresin',
                        value: vibrationEnabled,
                        enabled: notificationsEnabled,
                        onChanged: (value) => setState(() => vibrationEnabled = value),
                      ),
                      _buildSwitchCard(
                        icon: Icons.push_pin,
                        title: 'Kalıcı Bildirim',
                        subtitle: 'İlaç alınana kadar göster',
                        value: persistentNotification,
                        enabled: notificationsEnabled,
                        onChanged: (value) => setState(() => persistentNotification = value),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'ZAMANLAMA',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2)),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'İlaç saatinden kaç dakika önce bildirim gönderilsin?',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$reminderBefore dakika önce',
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 10),
                            Slider(
                              value: reminderBefore.toDouble(),
                              min: 0,
                              max: 60,
                              divisions: 12,
                              label: '$reminderBefore dk',
                              activeColor: Colors.blue.shade500,
                              onChanged: notificationsEnabled
                                  ? (value) {
                                      final intValue = value.toInt();
                                      setState(() => reminderBefore = intValue);
                                      _saveReminderBefore(intValue);
                                    }
                                  : null,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('0 dk', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                                Text('30 dk', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                                Text('60 dk', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        enabled: enabled,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: enabled ? [Colors.blue.shade500, Colors.purple.shade600] : [Colors.grey.shade300, Colors.grey.shade400],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: enabled ? Colors.black87 : Colors.grey.shade400),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: enabled ? Colors.grey.shade600 : Colors.grey.shade400),
        ),
        trailing: Switch(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeColor: Colors.blue.shade500,
        ),
      ),
    );
  }
}
