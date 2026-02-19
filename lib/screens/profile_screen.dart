import 'package:flutter/material.dart';

import '../services/user_profile_service.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _adController = TextEditingController();
  final _soyadController = TextEditingController();
  final _mailController = TextEditingController();
  final _sifreController = TextEditingController();
  final _yasController = TextEditingController();
  final _service = UserProfileService();

  UserProfile? _original;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _adController.dispose();
    _soyadController.dispose();
    _mailController.dispose();
    _sifreController.dispose();
    _yasController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final profile = await _service.getProfile(widget.userId);
      if (!mounted) return;
      _original = profile;
      _adController.text = profile.ad;
      _soyadController.text = profile.soyad;
      _mailController.text = profile.mail;
      _sifreController.text = profile.sifre;
      _yasController.text = profile.yas.toString();
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  bool get _hasChanges {
    final o = _original;
    if (o == null) return false;
    return _adController.text.trim() != o.ad ||
        _soyadController.text.trim() != o.soyad ||
        _mailController.text.trim() != o.mail ||
        _sifreController.text != o.sifre ||
        _yasController.text.trim() != o.yas.toString();
  }

  Future<void> _save() async {
    if (_saving || !_hasChanges) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);
    try {
      final updated = await _service.updateProfile(
        userId: widget.userId,
        ad: _adController.text.trim(),
        soyad: _soyadController.text.trim(),
        mail: _mailController.text.trim(),
        sifre: _sifreController.text,
        yas: int.parse(_yasController.text.trim()),
      );
      if (!mounted) return;
      setState(() => _original = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bilgiler guncellendi')),
      );
      Navigator.pop(context, updated);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Guncelleme basarisiz')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5), Color(0xFFE8F5E9), Colors.white],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    onChanged: () => setState(() {}),
                    child: Column(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade500, Colors.purple.shade600],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.25),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.person, color: Colors.white, size: 46),
                        ),
                        const SizedBox(height: 18),
                        _buildCard(
                          child: Column(
                            children: [
                              _field(_adController, 'Ad'),
                              const SizedBox(height: 12),
                              _field(_soyadController, 'Soyad'),
                              const SizedBox(height: 12),
                              _field(_mailController, 'Mail', keyboardType: TextInputType.emailAddress),
                              const SizedBox(height: 12),
                              _field(_sifreController, 'Sifre'),
                              const SizedBox(height: 12),
                              _field(_yasController, 'Yas', keyboardType: TextInputType.number),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (_hasChanges && !_saving) ? _save : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              disabledBackgroundColor: Colors.blueGrey.shade200,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _saving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text(
                                    'Kaydet',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
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

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.14),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.blueGrey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueGrey.shade100),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueGrey.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 1.8),
        ),
      ),
      validator: (value) {
        final v = (value ?? '').trim();
        if (v.isEmpty) return '$label zorunlu';
        if (label == 'Mail' && !v.contains('@')) return 'Gecerli mail girin';
        if (label == 'Yas') {
          final age = int.tryParse(v);
          if (age == null || age < 0) return 'Gecerli yas girin';
        }
        return null;
      },
    );
  }
}
