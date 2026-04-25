import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final _supabase = Supabase.instance.client;

  // Ambil semua produk yang aktif
  Future<List<Map<String, dynamic>>> getActiveProducts() async {
    return await _supabase
        .from('produk')
        .select('*, profiles(username)')
        .eq('status', 'aktif');
  }

  // Tambah produk baru (hanya untuk role penjual)
  Future<void> addProduct(
    String nama,
    double harga,
    String deskripsi,
    String? filePath,
  ) async {
    await _supabase.from('produk').insert({
      'user_id': _supabase.auth.currentUser!.id,
      'nama_produk': nama,
      'harga': harga,
      'deskripsi': deskripsi,
      'file_path': filePath,
    });
  }
}
