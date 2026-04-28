import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/auth_service.dart';
import '../home/home_screen.dart';
import '../seller/seller_dashboard_screen.dart';
import 'register_screen.dart';

// ============================================================
// LOGIN SCREEN - Polished UI
// Menggantikan: pbl/lib/screens/auth/login_screen.dart
// ============================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  bool _isLoading = false;

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
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
            .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await AuthService().login(_emailCtrl.text.trim(), _passCtrl.text);
      if (!mounted) return;

      // Cek role pengguna dan arahkan ke halaman yang sesuai
      final role = await AuthService().getMyRole();

      if (!mounted) return;

      if (role == 'penjual') {
        // Arahkan ke Seller Dashboard untuk penjual
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SellerDashboardScreen()),
          (route) => false,
        );
      } else {
        // Arahkan ke Home Screen untuk pembeli dan role lainnya
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          backgroundColor: const Color(0xFFFF4D67),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    const SizedBox(height: 60),

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
                      child: Text('ByteMe',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1D2E),
                              letterSpacing: -0.5)),
                    ),
                    const SizedBox(height: 6),
                    const Center(
                      child: Text('Masuk ke akun kamu',
                          style: TextStyle(
                              fontSize: 13, color: Color(0xFF9098B1))),
                    ),
                    const SizedBox(height: 40),

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
                          'Masukkan email kamu', Icons.email_outlined),
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
                          'Masukkan password kamu', Icons.lock_outline_rounded,
                          suffix: GestureDetector(
                            onTap: () => setState(() => _obscure = !_obscure),
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

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
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
                            : const Text('Masuk',
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
                          const Text('Belum punya akun? ',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFF9098B1))),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const RegisterScreen())),
                            child: const Text('Daftar',
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
      prefixIcon: Icon(icon, color: const Color(0xFF9098B1), size: 20),
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
      errorStyle: const TextStyle(fontSize: 11, color: Color(0xFFFF4D67)),
    );
  }
}