import 'package:flutter/material.dart';
import 'reminder_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Varsayılan seçili dil
  String _selectedLanguage = 'Türkçe';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE0F7FA), // Turkuaz tonları (Giriş ekranıyla uyumlu)
            Color(0xFFB2EBF2),
            Color(0xFF80DEEA),
            Colors.white,
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
              const Text(
                'Ayarlar',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              
              // 1. Bildirimler
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

              // 2. Dil Seçeneği (Seçilen dili gösteriyor)
              _buildSettingsCard(
                icon: Icons.language_outlined, 
                title: 'Dil', 
                subtitle: _selectedLanguage, // Seçili dil burada yazar
                onTap: () => _showLanguageDialog(),
              ),

              // 3. Yardım & Destek (Formlu Yapı)
              _buildSettingsCard(
                icon: Icons.help_outline, 
                title: 'Yardım & Destek', 
                subtitle: 'Bize ulaşın', 
                onTap: () => _showSupportDialog(),
              ),

              // 4. Uygulama Hakkında
              _buildSettingsCard(
                icon: Icons.info_outline, 
                title: 'Uygulama Hakkında', 
                subtitle: 'Versiyon 1.0.0', 
                onTap: () => _showAboutDialog(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- DİL SEÇİM PENCERESİ ---
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Dil Seçin'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        children: [
          _buildLanguageOption('Türkçe', '🇹🇷'),
          _buildLanguageOption('English', '🇺🇸'),
          _buildLanguageOption('Deutsch', '🇩🇪'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language, String flag) {
    bool isSelected = _selectedLanguage == language;
    return SimpleDialogOption(
      onPressed: () {
        setState(() {
          _selectedLanguage = language;
        });
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Text(
              language,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue.shade700 : Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  // --- YARDIM & DESTEK PENCERESİ (FORM İÇEREN) ---
  void _showSupportDialog() {
    final TextEditingController _messageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Klavye açılınca yukarı kayması için
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        // Klavye boşluğu için padding
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.support_agent, size: 32, color: Colors.blue),
                const SizedBox(width: 12),
                const Text('Bize Ulaşın', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Sorunlarınızı veya önerilerinizi aşağıya yazıp bize gönderebilirsiniz.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            
            // E-posta Adresi Gösterimi
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  const Icon(Icons.email_outlined, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'yardimdestek42@gmail.com',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Mesaj Yazma Alanı
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Mesajınız buraya...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Gönder Butonu
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Burada ileride mail gönderme işlemi yapılacak
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Mesajınız alındı! En kısa sürede dönüş yapacağız.'),
                      backgroundColor: Colors.green.shade600,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Gönder', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- HAKKINDA PENCERESİ ---
  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'İlaç Takip',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.medical_services, size: 40, color: Colors.blue),
      ),
      children: [
        const SizedBox(height: 16),
        const Text(
          'Bu uygulama, günlük ilaç takibinizi kolaylaştırmak, unutkanlığı önlemek ve alerjen kontrolü sağlayarak güvenli ilaç kullanımını desteklemek amacıyla geliştirilmiştir.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 16),
        const Text(
          'Özellikler:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('• QR Kod ile hızlı ilaç ekleme'),
        const Text('• Alerjen kontrol sistemi'),
        const Text('• Düzenli hatırlatmalar'),
        const SizedBox(height: 24),
        const Text(
          '© 2026 İlaç Takip Uygulaması\nTüm Hakları Saklıdır.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
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
            gradient: LinearGradient(colors: [Colors.cyan.shade400, Colors.blue.shade600]),
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