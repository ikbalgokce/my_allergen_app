import 'package:flutter/material.dart';

import '../services/allergen_service.dart';

class AllergenProfileScreen extends StatefulWidget {
  final int userId;

  const AllergenProfileScreen({super.key, required this.userId});

  @override
  State<AllergenProfileScreen> createState() => _AllergenProfileScreenState();
}

class _AllergenProfileScreenState extends State<AllergenProfileScreen> {
  final AllergenService _allergenService = AllergenService();
  bool _isLoading = true;
  List<String> _allergens = const [];

  @override
  void initState() {
    super.initState();
    _loadAllergens();
  }

  Future<void> _loadAllergens() async {
    setState(() => _isLoading = true);
    try {
      final allergens = await _allergenService.getAllergens(widget.userId);
      if (!mounted) return;
      setState(() => _allergens = allergens);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _removeAllergen(String allergenName) async {
    final updated = await _allergenService.removeAllergen(
      userId: widget.userId,
      allergenName: allergenName,
    );
    if (!mounted) return;
    setState(() => _allergens = updated);
  }

  Future<void> _openAddAllergenScreen() async {
    final newName = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const _AddAllergenScreen()),
    );
    if (!mounted || newName == null || newName.trim().isEmpty) return;

    final updated = await _allergenService.addAllergen(
      userId: widget.userId,
      allergenName: newName.trim(),
    );
    if (!mounted) return;
    setState(() => _allergens = updated);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      Text('Guvenliginiz icin', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              InkWell(
                onTap: _openAddAllergenScreen,
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
                      const Expanded(child: Text('Alerjen Ekle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                      Icon(Icons.chevron_right, color: Colors.grey.shade400),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'KAYITLI ALERJENLER (${_allergens.length})',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
              ),
              const SizedBox(height: 12),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_allergens.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
                  ),
                  child: const Text('Kayitli alerjen bulunamadi.'),
                )
              else
                ..._allergens.map(
                  (name) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        InkWell(
                          onTap: () => _removeAllergen(name),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                            child: Icon(Icons.close, size: 18, color: Colors.red.shade600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  border: Border.all(color: Colors.amber.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.amber.shade700, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Guvenliginiz icin alerjen bilgilerinizi guncel tutun.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.amber.shade900,
                          fontWeight: FontWeight.w600,
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
        ),
      ),
    );
  }
}

class _AddAllergenScreen extends StatefulWidget {
  const _AddAllergenScreen();

  @override
  State<_AddAllergenScreen> createState() => _AddAllergenScreenState();
}

class _AddAllergenScreenState extends State<_AddAllergenScreen> {
  final TextEditingController _controller = TextEditingController();

  bool get _canSubmit => _controller.text.trim().isNotEmpty;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text('Alerjen Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Alerjen adi',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Orn: Penisilin',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _canSubmit ? () => Navigator.pop(context, _controller.text.trim()) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Ekle', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
