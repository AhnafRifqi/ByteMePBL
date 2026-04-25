import 'package:flutter/material.dart';
import '../../../services/product_service.dart';

class AddProdukScreen extends StatefulWidget {
  const AddProdukScreen({super.key});

  @override
  State<AddProdukScreen> createState() => _AddProdukScreenState();
}

class _AddProdukScreenState extends State<AddProdukScreen> {
  final _nama = TextEditingController();
  final _harga = TextEditingController();
  final _deskripsi = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jual Karya Digital')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nama,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _harga,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Harga (Rp)',
                prefixText: 'Rp ',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _deskripsi,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Deskripsi Singkat'),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {
                // Di project asli, gunakan package: file_picker di sini
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pilih file ZIP/PDF (Mock)')),
                );
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload File Produk Digital'),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      try {
                        await ProductService().addProduct(
                          _nama.text,
                          double.parse(_harga.text),
                          _deskripsi.text,
                          'mock_path/file.zip', // Dummy path karena file picker belum diinstal
                        );
                        Navigator.pop(context); // Kembali ke list produk
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Gagal: $e')));
                      } finally {
                        setState(() => _isLoading = false);
                      }
                    },
                    child: const Text('Terbitkan Produk'),
                  ),
          ],
        ),
      ),
    );
  }
}
