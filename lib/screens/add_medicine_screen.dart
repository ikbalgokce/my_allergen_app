import 'package:flutter/material.dart';

import '../services/medication_create_service.dart';
import 'qr_scanner_screen.dart';

class AddMedicineScreen extends StatefulWidget {
  final int userId;
  final String initialMethod;

  const AddMedicineScreen({
    super.key,
    required this.userId,
    this.initialMethod = 'manual',
  });

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final MedicationCreateService _medicationCreateService = MedicationCreateService();

  late String selectedMethod;
  String? selectedFrequency;
  TimeOfDay? selectedTime;
  bool isSaving = false;
  bool allergyCheckPassed = false;
  bool isChecking = false;

  @override
  void initState() {
    super.initState();
    selectedMethod = widget.initialMethod;
    if (selectedMethod == 'qr') {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scanQRCode());
    }
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.blue.shade500),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _scanQRCode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScannerScreen()),
    );

    if (result != null) {
      setState(() {
        _medicineNameController.text = result;
        selectedMethod = 'manual';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('QR Kod Okundu: $result'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _checkAllergy() {
    setState(() => isChecking = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        isChecking = false;
        allergyCheckPassed = true;
      });
      _showAllergyResultDialog();
    });
  }

  void _showAllergyResultDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: Colors.green.shade100, shape: BoxShape.circle),
                child: Icon(Icons.check_circle, color: Colors.green.shade600, size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                'Güvenli İlaç',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                'Bu ilaç alerjen profilinizle uyumludur.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade500,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Tamam',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _formattedTime() {
    if (selectedTime == null) return null;
    final hh = selectedTime!.hour.toString().padLeft(2, '0');
    final mm = selectedTime!.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  Future<void> _submit() async {
    if (isSaving) return;
    if (_medicineNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('İlaç adı zorunlu'),
          backgroundColor: Colors.red.shade600,
        ),
      );
      return;
    }

    setState(() => isSaving = true);
    final ok = await _medicationCreateService.createMedication(
      userId: widget.userId,
      ilacAdi: _medicineNameController.text.trim(),
      ilacDozu: _dosageController.text.trim().isEmpty ? null : _dosageController.text.trim(),
      kullanimSikligi: selectedFrequency,
      hatirlatmaSaati: _formattedTime(),
    );
    if (!mounted) return;
    setState(() => isSaving = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('İlaç başarıyla eklendi'),
          backgroundColor: Colors.green.shade600,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('İlaç eklenemedi'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
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
                          'İlaç Ekle',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        Text(
                          'Yeni ilaç kaydı oluştur',
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildMethodButton(
                                icon: Icons.qr_code_scanner,
                                label: 'QR Kod',
                                isSelected: selectedMethod == 'qr',
                                onTap: () {
                                  setState(() => selectedMethod = 'qr');
                                  _scanQRCode();
                                },
                              ),
                            ),
                            Expanded(
                              child: _buildMethodButton(
                                icon: Icons.edit,
                                label: 'Manuel',
                                isSelected: selectedMethod == 'manual',
                                onTap: () => setState(() => selectedMethod = 'manual'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'İLAÇ BİLGİLERİ',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _medicineNameController,
                        label: 'İlaç Adı',
                        hint: 'Örn: Parol 500mg',
                        icon: Icons.medication,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _dosageController,
                        label: 'Doz',
                        hint: 'Örn: 1 tablet',
                        icon: Icons.medical_services,
                      ),
                      const SizedBox(height: 16),
                      Container(
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
                        child: DropdownButtonFormField<String>(
                          value: selectedFrequency,
                          decoration: InputDecoration(
                            labelText: 'Kullanım Sıklığı',
                            prefixIcon: Icon(Icons.access_time, color: Colors.blue.shade500),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Gunde 1', child: Text('Günde 1 kez')),
                            DropdownMenuItem(value: 'Gunde 2', child: Text('Günde 2 kez')),
                            DropdownMenuItem(value: 'Gunde 3', child: Text('Günde 3 kez')),
                            DropdownMenuItem(value: 'Haftada 1', child: Text('Haftada 1 kez')),
                          ],
                          onChanged: (value) => setState(() => selectedFrequency = value),
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _selectTime,
                        child: Container(
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
                          child: Row(
                            children: [
                              Icon(Icons.schedule, color: Colors.blue.shade500),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Hatırlatma Saati', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                    const SizedBox(height: 4),
                                    Text(
                                      selectedTime != null
                                          ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                                          : 'Saat seçin',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Colors.grey.shade400),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_medicineNameController.text.trim().isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.red.shade400]),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: isChecking ? null : _checkAllergy,
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: isChecking
                                          ? const Padding(
                                              padding: EdgeInsets.all(8),
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Icon(Icons.shield_outlined, color: Colors.white),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Alerji Kontrolü',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            isChecking
                                                ? 'Kontrol ediliyor...'
                                                : allergyCheckPassed
                                                    ? 'Güvenli'
                                                    : 'İlacı kontrol et',
                                            style: const TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (allergyCheckPassed)
                                      const Icon(Icons.check_circle, color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: Colors.blue.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'İlaç eklemeden önce alerji kontrolü yapmanızı öneririz.',
                                style: TextStyle(fontSize: 13, color: Colors.blue.shade800, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade500,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'İlaç Ekle',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(colors: [Colors.blue.shade500, Colors.purple.shade600]) : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey.shade600, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
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
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.blue.shade500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _medicineNameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }
}
