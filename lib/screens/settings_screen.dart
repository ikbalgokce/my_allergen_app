import 'package:flutter/material.dart';
import 'reminder_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFE5E5), // Soft pembe
            Color(0xFFFFE8CC), // Soft turuncu
            Color(0xFFFFF4E0), // Soft sarı
            Color(0xFFE8F8F5), // Mint yeşil
          ],
          stops: [0.0, 0.35, 0.65, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ayarlar', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _buildSettingsCard(
                icon: Icons.notifications_outlined, 
                title: 'Bildirimler', 
                subtitle: 'Hatırlatma ayarları', 
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReminderSettingsScreen(),
                    ),
                  );
                },
              ),
              _buildSettingsCard(icon: Icons.language_outlined, title: 'Dil', subtitle: 'Türkçe', onTap: () {}),
              _buildSettingsCard(icon: Icons.help_outline, title: 'Yardım & Destek', subtitle: 'SSS ve iletişim', onTap: () {}),
              _buildSettingsCard(icon: Icons.info_outline, title: 'Uygulama Hakkında', subtitle: 'Versiyon 1.0.0', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blue.shade500, Colors.purple.shade600]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
      ),
    );
  }
}