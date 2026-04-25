import 'package:flutter/material.dart';

class AdminGuard extends StatelessWidget {
  final Widget child;
  final bool isAdmin;

  const AdminGuard({Key? key, required this.child, required this.isAdmin})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Akses Ditolak')),
        body: const Center(
          child: Text('Anda tidak memiliki akses ke halaman ini'),
        ),
      );
    }

    return child;
  }
}
