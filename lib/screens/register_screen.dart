import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _kvkkAccepted = false;
  bool _isLoading = false;

  Future<void> _register() async {
    if (_isLoading) return;

    if (_nameController.text.isEmpty ||
        _surnameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lütfen tüm alanları doldurun'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    final yas = int.tryParse(_ageController.text.trim());
    if (yas == null || yas < 0 || yas > 130) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Yaş bilgisi geçerli bir sayı olmalı (0-130)'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Şifreler eşleşmiyor'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    if (!_kvkkAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('KVKK metnini okuyup onaylamalısınız'),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await _authService.register(
        ad: _nameController.text.trim(),
        soyad: _surnameController.text.trim(),
        mail: _emailController.text.trim(),
        sifre: _passwordController.text,
        kullaniciAd: _usernameController.text.trim(),
        yas: yas,
      );

      if (!mounted) return;

      if ((result.statusCode == 201 || result.statusCode == 200) && result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Kayıt başarılı! Giriş yapabilirsiniz.'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
        Navigator.pop(context);
        return;
      }

      if (result.statusCode == 409 || result.code == 'MAIL_EXISTS') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Bu e-posta zaten kayıtlı'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Kayıt işlemi başarısız'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Sunucuya bağlanılamadı'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showKVKKDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 500),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'KVKK Aydınlatma Metni',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    '''6698 sayılı Kişisel Verilerin Korunması Kanunu (KVKK) uyarınca, kişisel verileriniz İlaç Takip Uygulaması tarafından aşağıda belirtilen kapsamda işlenebilir.

Toplanan Veriler:
- Ad, soyad ve iletişim bilgileri
- Sağlık bilgileri (ilaç kullanımı, alerji)
- Uygulama kullanım verileri

Verilerin İşlenme Amacı:
- İlaç takibi ve hatırlatma hizmeti sunmak
- Alerji kontrolü yapmak
- Uygulamayı geliştirmek''',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _kvkkAccepted = true);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade500,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Okudum ve Onaylıyorum',
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

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blue.shade500),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade500, width: 2),
      ),
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Kayıt Ol',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(controller: _nameController, decoration: _inputDecoration('Ad', Icons.person)),
                          const SizedBox(height: 16),
                          TextField(controller: _surnameController, decoration: _inputDecoration('Soyad', Icons.person_outline)),
                          const SizedBox(height: 16),
                          TextField(controller: _usernameController, decoration: _inputDecoration('Kullanıcı Adı', Icons.alternate_email)),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('Yaş', Icons.cake_outlined),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _inputDecoration('E-posta', Icons.email),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: _inputDecoration('Şifre', Icons.lock).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: _inputDecoration('Şifre Tekrar', Icons.lock_outline).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: _showKVKKDialog,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _kvkkAccepted,
                                  onChanged: (value) {
                                    if (value == true) {
                                      _showKVKKDialog();
                                    } else {
                                      setState(() => _kvkkAccepted = false);
                                    }
                                  },
                                  activeColor: Colors.blue.shade500,
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                                      children: [
                                        const TextSpan(text: 'KVKK '),
                                        TextSpan(
                                          text: 'Aydınlatma Metni',
                                          style: TextStyle(
                                            color: Colors.blue.shade600,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        const TextSpan(text: '\'ni okudum ve onaylıyorum'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade500,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text(
                                      'Kayıt Ol',
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ],
                      ),
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

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
