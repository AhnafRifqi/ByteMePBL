import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';

// ============================================================
// REGISTER SCREEN - Polished UI
// Menggantikan: pbl/lib/screens/auth/register_screen.dart
// ============================================================

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  String _selectedRole = 'pembeli';

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
            CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await AuthService().register(
        _emailCtrl.text.trim(),
        _passCtrl.text,
        _usernameCtrl.text.trim(),
        _selectedRole,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Registrasi berhasil! Silakan login.'),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
      ));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          backgroundColor: const Color(0xFFFF4D67),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Logo
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6B7FD7),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFF6B7FD7).withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 8))
                          ],
                        ),
                        child: const Icon(Icons.storefront_rounded,
                            color: Colors.white, size: 40),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Center(
                      child: Text('Buat Akun Baru',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1D2E))),
                    ),
                    const SizedBox(height: 6),
                    const Center(
                      child: Text('Isi data kamu untuk memulai',
                          style: TextStyle(
                              fontSize: 13, color: Color(0xFF9098B1))),
                    ),

                    const SizedBox(height: 32),

                    // Role selector
                    _label('Daftar sebagai'),
                    const SizedBox(height: 10),
                    _buildRoleSelector(),

                    const SizedBox(height: 20),

                    // Username
                    _label('Username'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _usernameCtrl,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF1A1D2E)),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Username tidak boleh kosong';
                        }
                        if (v.trim().length < 3) {
                          return 'Username min. 3 karakter';
                        }
                        return null;
                      },
                      decoration: _inputDecoration(
                          'Masukkan username', Icons.person_outline_rounded),
                    ),

                    const SizedBox(height: 16),

                    // Email
                    _label('Email'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF1A1D2E)),
                      validator: (v) => (v == null || !v.contains('@'))
                          ? 'Format email tidak valid'
                          : null,
                      decoration: _inputDecoration(
                          'Masukkan email', Icons.email_outlined),
                    ),

                    const SizedBox(height: 16),

                    // Password
                    _label('Password'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF1A1D2E)),
                      validator: (v) => (v == null || v.length < 6)
                          ? 'Password min. 6 karakter'
                          : null,
                      decoration: _inputDecoration(
                          'Masukkan password', Icons.lock_outline_rounded,
                          suffix: GestureDetector(
                            onTap: () =>
                                setState(() => _obscure = !_obscure),
                            child: Icon(
                              _obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: const Color(0xFF9098B1),
                              size: 20,
                            ),
                          )),
                    ),

                    const SizedBox(height: 28),

                    // Register button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B7FD7),
                          disabledBackgroundColor:
                              const Color(0xFF6B7FD7).withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5))
                            : const Text('Daftar Sekarang',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Sudah punya akun? ',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFF9098B1))),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text('Masuk',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF6B7FD7))),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          _roleOption('pembeli', Icons.shopping_bag_outlined, 'Pembeli'),
          _roleOption('penjual', Icons.storefront_outlined, 'Penjual'),
        ],
      ),
    );
  }

  Widget _roleOption(String role, IconData icon, String label) {
    final bool isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF6B7FD7)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16,
                  color: isSelected
                      ? Colors.white
                      : const Color(0xFF9098B1)),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF9098B1))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1D2E)));

  InputDecoration _inputDecoration(String hint, IconData icon,
      {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          const TextStyle(color: Color(0xFFB0B8CC), fontSize: 14),
      prefixIcon:
          Icon(icon, color: const Color(0xFF9098B1), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFFE8ECF4), width: 1)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: Color(0xFF6B7FD7), width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: Color(0xFFFF4D67), width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: Color(0xFFFF4D67), width: 1.5)),
      errorStyle:
          const TextStyle(fontSize: 11, color: Color(0xFFFF4D67)),
    );
  }
}