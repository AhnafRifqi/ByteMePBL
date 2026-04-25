import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../buyer/product/list_product_page.dart';
import '../admin/review_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Marketplace'),
        actions: [
          IconButton(
            onPressed: () => AuthService().logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ListProdukScreen()),
              ),
              child: const Text('Lihat Produk'),
            ),
            const SizedBox(height: 10),
            FutureBuilder<String?>(
              future: AuthService().getMyRole(),
              builder: (context, snapshot) {
                if (snapshot.data == 'admin') {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PeninjauanScreen(),
                      ),
                    ),
                    child: const Text('Panel Admin'),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
