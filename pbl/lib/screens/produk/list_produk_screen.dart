import 'package:flutter/material.dart';
import '../../services/product_service.dart';
import '../../services/auth_service.dart';
import 'add_produk_screen.dart';

class ListProdukScreen extends StatefulWidget {
  const ListProdukScreen({super.key});

  @override
  State<ListProdukScreen> createState() => _ListProdukScreenState();
}

class _ListProdukScreenState extends State<ListProdukScreen> {
  final _productService = ProductService();
  String? _myRole;

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    final role = await AuthService().getMyRole();
    setState(() => _myRole = role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Etalase Produk Digital')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _productService.getActiveProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada produk.'));
          }

          final produkList = snapshot.data!;
          return ListView.builder(
            itemCount: produkList.length,
            itemBuilder: (context, index) {
              final produk = produkList[index];
              // Mengambil username penjual dari tabel relasi (profiles)
              final namaPenjual = produk['profiles']['username'] ?? 'Anonim';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.file_present, size: 40, color: Colors.indigo),
                  title: Text(produk['nama_produk'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Oleh: $namaPenjual\nRp ${produk['harga']}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // TODO: Navigasi ke DetailProdukScreen / Tambah ke keranjang
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur Keranjang menyusul!')));
                    },
                    child: const Text('Beli'),
                  ),
                ),
              );
            },
          );
        },
      ),
      // Hanya tampilkan tombol tambah produk jika user adalah 'penjual'
      floatingActionButton: _myRole == 'penjual'
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProdukScreen()))
                  .then((_) => setState(() {})); // Refresh list setelah nambah produk
              },
              icon: const Icon(Icons.add),
              label: const Text('Jual Produk'),
            )
          : null,
    );
  }
}