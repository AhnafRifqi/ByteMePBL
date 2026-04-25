import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../home/home_page.dart';
import 'register_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Marketplace')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<AuthController>(
          builder: (context, authController, child) {
            return Column(
              children: [
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  enabled: !_isLoading,
                ),
                TextField(
                  controller: _pass,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 20),
                if (authController.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Error: ${authController.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() => _isLoading = true);
                          try {
                            await authController.login(
                              _email.text.trim(),
                              _pass.text,
                            );
                            if (mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                        child: const Text('Masuk'),
                      ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          ),
                  child: const Text('Belum punya akun? Daftar'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}