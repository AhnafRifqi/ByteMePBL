import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AdminGuard extends StatelessWidget {
  final Widget child;
  const AdminGuard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthService().getMyRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data == 'admin') return child;
        return const Scaffold(
          body: Center(child: Text('⛔ Akses Khusus Admin')),
        );
      },
    );
  }
}
