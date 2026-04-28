import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

// ============================================================
// ADMIN GUARD - Polished UI
// Path: pbl/lib/widgets/admin_guard.dart
// ============================================================

class AdminGuard extends StatelessWidget {
  final Widget child;
  const AdminGuard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthService().getMyRole(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: const Color(0xFFF0F2F8),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B7FD7).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                        Icons.admin_panel_settings_outlined,
                        color: Color(0xFF6B7FD7),
                        size: 36),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        color: Color(0xFF6B7FD7), strokeWidth: 2.5),
                  ),
                  const SizedBox(height: 12),
                  const Text('Memverifikasi akses...',
                      style: TextStyle(
                          fontSize: 13, color: Color(0xFF9098B1))),
                ],
              ),
            ),
          );
        }

        // Bukan admin
        if (snapshot.data != 'admin') {
          return Scaffold(
            backgroundColor: const Color(0xFFF0F2F8),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xFFF0F2F8),
                    borderRadius: BorderRadius.circular(12)),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF1A1D2E), size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              title: const Text('Akses Ditolak',
                  style: TextStyle(
                      color: Color(0xFF1A1D2E),
                      fontWeight: FontWeight.bold)),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.lock_outline_rounded,
                          color: Colors.red.shade400, size: 44),
                    ),
                    const SizedBox(height: 24),
                    const Text('Akses Khusus Admin',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1D2E))),
                    const SizedBox(height: 10),
                    const Text(
                      'Kamu tidak memiliki izin untuk\nmengakses halaman ini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9098B1),
                          height: 1.6),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B7FD7),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Kembali',
                            style: TextStyle(
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Admin - tampilkan konten
        return child;
      },
    );
  }
}