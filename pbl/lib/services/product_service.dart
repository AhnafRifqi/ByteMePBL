import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class ProductService {
  final _supabase = Supabase.instance.client;

  // Ambil semua produk yang aktif
  Future<List<Map<String, dynamic>>> getActiveProducts() async {
    return await _supabase
        .from('produk')
        .select('*, profiles(username)')
        .eq('status', 'aktif');
  }

  // Get products as ProductModel
  Future<List<ProductModel>> getProducts() async {
    final data = await getActiveProducts();
    return data.map((map) => ProductModel.fromMap(map)).toList();
  }

  // Get product by id
  Future<ProductModel?> getProductById(String produkId) async {
    final data = await _supabase
        .from('produk')
        .select('*, profiles(username)')
        .eq('produk_id', produkId)
        .eq('status', 'aktif')
        .single();
    return data.isNotEmpty ? ProductModel.fromMap(data) : null;
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
