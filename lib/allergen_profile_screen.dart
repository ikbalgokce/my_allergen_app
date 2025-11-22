import 'package:flutter/material.dart';

// Data Model (Sınıf)
class Allergen {
  final int id;
  final String name;
  final String category;
  final String severity;
  final String date;

  Allergen({
    required this.id,
    required this.name,
    required this.category,
    required this.severity,
    required this.date,
  });
}

class AllergenProfileScreen extends StatefulWidget {
  const AllergenProfileScreen({Key? key}) : super(key: key);

  @override
  State<AllergenProfileScreen> createState() => _AllergenProfileScreenState();
}

class _AllergenProfileScreenState extends State<AllergenProfileScreen> {
  // Veri yapısı
  List<Allergen> allergens = [
    Allergen(id: 1, name: 'Penisilin', category: 'Antibiyotik', severity: 'Yüksek', date: '2024'),
    Allergen(id: 2, name: 'Aspirin', category: 'Ağrı Kesici', severity: 'Orta', date: '2023'),
    Allergen(id: 3, name: 'Laktoz', category: 'Yardımcı Madde', severity: 'Düşük', date: '2022'),
  ];

  void _removeAllergen(int id) {
    setState(() {
      allergens.removeWhere((allergen) => allergen.id == id);
    });
  }

  void _showAddModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddAllergenModal(),
    );
  }

  // Yüksek, Orta ve Düşük risk için arka plan rengi
  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Yüksek':
        return Colors.red.shade200; // Koyu kırmızı arka plan
      case 'Orta':
        return Colors.orange.shade100;
      case 'Düşük':
        return Colors.yellow.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  // Yüksek, Orta ve Düşük risk için yazı rengi
  Color _getSeverityTextColor(String severity) {
    switch (severity) {
      case 'Yüksek':
        return Colors.red.shade800; // Koyu kırmızı yazı
      case 'Orta':
        return Colors.orange.shade700;
      case 'Düşük':
        return Colors.yellow.shade800;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Center ve SizedBox(width: 600) kaldırıldı
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // ARKA PLAN: Açık Mavi/İndigo geçişi
            colors: [
              Colors.indigo.shade50,
              Colors.white,
              Colors.lightBlue.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    // HEADER ICON (Cyan-İndigo)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.cyan.shade600, Colors.indigo.shade700],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Alerjen Profilim',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Güvenliğiniz için',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info Card
                      Container(
                        decoration: BoxDecoration(
                          // ANA KART RENKLERİ (Cyan-İndigo)
                          gradient: LinearGradient(
                            colors: [Colors.cyan.shade600, Colors.indigo.shade700],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyan.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.shield,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Alerjen Güvencesi Aktif',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Eklediğiniz her ilaç otomatik olarak alerjenlerinizle karşılaştırılır ve güvenlik kontrolü yapılır.',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _buildStatusChip('${allergens.length} Alerjen Kayıtlı', Colors.white),
                                const SizedBox(width: 8),
                                // SİSTEM AKTİF RENGİ CANLI LİMON YEŞİLİ
                                _buildStatusChip('Sistem Aktif', Colors.lime.shade300), 
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Add Button
                      InkWell(
                        onTap: _showAddModal,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            // BUTON ÇERÇEVESİ ANA RENGE YAKIN İNDİGO
                            border: Border.all(
                              color: Colors.indigo.shade400, 
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // BUTON ICON ARKA PLANI (Cyan-İndigo)
                              Container(
                                width: 10,
                                height: 5,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.cyan.shade600, Colors.indigo.shade700],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.add, color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Yeni Alerjen Ekle',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Colors.grey.shade400),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // List Header
                      Text(
                        'KAYITLI ALERJENLER (${allergens.length})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Allergens List
                      ...allergens.map((allergen) => _buildAllergenCard(allergen)).toList(),

                      const SizedBox(height: 20),

                      // Warning Info (Amber/Sarı korundu)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          border: Border.all(color: Colors.amber.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.amber.shade700,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.amber.shade900,
                                    height: 1.5,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: 'Önemli: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: 'Alerjen bilgilerinizi güncel tutmak hayati önem taşır. Yeni bir alerji tespit edildiğinde hemen uygulamaya ekleyin.',
                                    ),
                                  ],
                                ),
                              ),
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

  // Yardımcı Widget: Durum Çipi
  Widget _buildStatusChip(String text, Color dotColor) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Yardımcı Widget: Alerjen Kartı
  Widget _buildAllergenCard(Allergen allergen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          allergen.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // RİSK ÇİPİ
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getSeverityColor(allergen.severity),
                            border: Border.all(
                              color: _getSeverityTextColor(allergen.severity),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${allergen.severity} Risk',
                            style: TextStyle(
                              fontSize: 10,
                              color: _getSeverityTextColor(allergen.severity),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      allergen.category,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // SİLME BUTONU
              InkWell(
                onTap: () => _removeAllergen(allergen.id),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.red.shade600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // AYIRICI ÇİZGİ
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Eklenme: ${allergen.date}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              // AKTİF TAKİP DURUMU
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.cyan.shade600, // Ana tema rengi kullanıldı
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Aktif Takipte',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.cyan.shade600, // Ana tema rengi kullanıldı
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Modal kısmı
class AddAllergenModal extends StatefulWidget {
  const AddAllergenModal({Key? key}) : super(key: key);

  @override
  State<AddAllergenModal> createState() => _AddAllergenModalState();
}

class _AddAllergenModalState extends State<AddAllergenModal> {
  String? selectedCategory;
  String? selectedSeverity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Yeni Alerjen Ekle',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Alerjiniz olan ilaç veya maddeyi ekleyin. Sistem otomatik olarak güvenlik kontrolü yapacaktır.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey, // Shade600 yerine Colors.grey kullanıldı
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                hintText: 'Alerjen adı (örn: Penisilin)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  // ODAK RENGİ GÜNCELLENDİ
                  borderSide: BorderSide(color: Colors.cyan.shade600, width: 2), 
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                hintText: 'Kategori seçin',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  // ODAK RENGİ GÜNCELLENDİ
                  borderSide: BorderSide(color: Colors.cyan.shade600, width: 2), 
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'Antibiyotik', child: Text('Antibiyotik')),
                DropdownMenuItem(value: 'Ağrı Kesici', child: Text('Ağrı Kesici')),
                DropdownMenuItem(value: 'Vitamin', child: Text('Vitamin')),
                DropdownMenuItem(value: 'Yardımcı Madde', child: Text('Yardımcı Madde')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedSeverity,
              decoration: InputDecoration(
                hintText: 'Risk seviyesi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  // ODAK RENGİ GÜNCELLENDİ
                  borderSide: BorderSide(color: Colors.cyan.shade600, width: 2), 
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'Yüksek', child: Text('Yüksek')),
                DropdownMenuItem(value: 'Orta', child: Text('Orta')),
                DropdownMenuItem(value: 'Düşük', child: Text('Düşük')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedSeverity = value;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Alerjen ekleme işlemi
                  Navigator.pop(context);
                },
                // EKLE BUTONU STİLİ (Cyan-İndigo)
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero, // Gradient için padding'i sıfırlıyoruz
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.cyan.shade600, Colors.indigo.shade700],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Alerjen Ekle',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}