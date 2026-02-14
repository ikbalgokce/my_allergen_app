import 'package:flutter/material.dart';
import '../models/allergen.dart';

class AllergenProfileScreen extends StatefulWidget {
  const AllergenProfileScreen({Key? key}) : super(key: key);

  @override
  State<AllergenProfileScreen> createState() => _AllergenProfileScreenState();
}

class _AllergenProfileScreenState extends State<AllergenProfileScreen> {
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
      builder: (context) => AddAllergenModal(
        onAdd: (name, category, severity) {
          setState(() {
            allergens.add(
              Allergen(
                id: allergens.length + 1,
                name: name,
                category: category,
                severity: severity,
                date: DateTime.now().year.toString(),
              ),
            );
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Yüksek': return Colors.red.shade100;
      case 'Orta': return Colors.orange.shade100;
      case 'Düşük': return Colors.yellow.shade100;
      default: return Colors.grey.shade100;
    }
  }

  Color _getSeverityTextColor(String severity) {
    switch (severity) {
      case 'Yüksek': return Colors.red.shade700;
      case 'Orta': return Colors.orange.shade700;
      case 'Düşük': return Colors.yellow.shade800;
      default: return Colors.grey.shade700;
    }
  }

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade500, Colors.purple.shade600],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Alerjen Profilim', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Güvenliğiniz için', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Info Card
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blue.shade500, Colors.purple.shade600]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.shield, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Alerjen Güvencesi Aktif', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text('Eklediğiniz her ilaç otomatik olarak alerjenlerinizle karşılaştırılır.', style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildStatusChip('${allergens.length} Alerjen Kayıtlı', Colors.white),
                        const SizedBox(width: 12),
                        _buildStatusChip('Sistem Aktif', Colors.green.shade300),
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
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.blue.shade500, Colors.purple.shade600]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(child: Text('Yeni Alerjen Ekle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                      Icon(Icons.chevron_right, color: Colors.grey.shade400),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'KAYITLI ALERJENLER (${allergens.length})',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
              ),
              const SizedBox(height: 12),

              // Allergens List
              ...allergens.map((allergen) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(allergen.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getSeverityColor(allergen.severity),
                                      border: Border.all(color: _getSeverityTextColor(allergen.severity)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text('${allergen.severity} Risk', style: TextStyle(fontSize: 10, color: _getSeverityTextColor(allergen.severity), fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(allergen.category, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => _removeAllergen(allergen.id),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                            child: Icon(Icons.close, size: 18, color: Colors.red.shade600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(height: 1, color: Colors.grey.shade200),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Eklenme: ${allergen.date}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        Row(
                          children: [
                            Icon(Icons.check_circle, size: 16, color: Colors.blue.shade600),
                            const SizedBox(width: 4),
                            Text('Aktif Takipte', style: TextStyle(fontSize: 12, color: Colors.blue.shade600, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )),

              const SizedBox(height: 20),

              // Warning Info
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
                    Icon(Icons.warning_amber_rounded, color: Colors.amber.shade700, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 14, color: Colors.amber.shade900, height: 1.5),
                          children: const [
                            TextSpan(text: 'Önemli: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'Alerjen bilgilerinizi güncel tutmak hayati önem taşır. Yeni bir alerji tespit edildiğinde hemen uygulamaya ekleyin.'),
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
    );
  }

  Widget _buildStatusChip(String text, Color dotColor) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

// Add Allergen Modal
class AddAllergenModal extends StatefulWidget {
  final Function(String, String, String) onAdd;
  
  const AddAllergenModal({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<AddAllergenModal> createState() => _AddAllergenModalState();
}

class _AddAllergenModalState extends State<AddAllergenModal> {
  final TextEditingController _nameController = TextEditingController();
  String? selectedCategory;
  String? selectedSeverity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Yeni Alerjen Ekle', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.close, size: 20, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Alerjiniz olan ilaç veya maddeyi ekleyin.', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Alerjen adı (örn: Penisilin)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                hintText: 'Kategori seçin',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              items: const [
                DropdownMenuItem(value: 'Antibiyotik', child: Text('Antibiyotik')),
                DropdownMenuItem(value: 'Ağrı Kesici', child: Text('Ağrı Kesici')),
                DropdownMenuItem(value: 'Vitamin', child: Text('Vitamin')),
                DropdownMenuItem(value: 'Yardımcı Madde', child: Text('Yardımcı Madde')),
              ],
              onChanged: (value) => setState(() => selectedCategory = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedSeverity,
              decoration: InputDecoration(
                hintText: 'Risk seviyesi',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              items: const [
                DropdownMenuItem(value: 'Yüksek', child: Text('Yüksek')),
                DropdownMenuItem(value: 'Orta', child: Text('Orta')),
                DropdownMenuItem(value: 'Düşük', child: Text('Düşük')),
              ],
              onChanged: (value) => setState(() => selectedSeverity = value),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty && selectedCategory != null && selectedSeverity != null) {
                    widget.onAdd(_nameController.text, selectedCategory!, selectedSeverity!);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade500,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Alerjen Ekle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}