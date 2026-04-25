import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/keranjang_model.dart';
import '../models/detail_keranjang_model.dart';

class KeranjangService {
  final _supabase = Supabase.instance.client;

  Future<KeranjangModel?> getMyCart() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final data = await _supabase
          .from('keranjang')
          .select()
          .eq('user_id', userId)
          .single();

      return KeranjangModel.fromMap(data);
    } catch (e) {
      print('Error getting cart: $e');
      return null;
    }
  }

  Future<List<DetailKeranjangModel>> getCartItems() async {
    try {
      final cart = await getMyCart();
      if (cart == null) return [];

      final data = await _supabase
          .from('detail_keranjang')
          .select()
          .eq('keranjang_id', cart.id);

      return (data as List)
          .map((item) => DetailKeranjangModel.fromMap(item))
          .toList();
    } catch (e) {
      print('Error getting cart items: $e');
      return [];
    }
  }

  Future<void> addToCart(
    String produkId,
    int jumlah,
    double hargaSatuan,
  ) async {
    try {
      final cart = await getMyCart();
      if (cart == null) throw Exception('Keranjang tidak ditemukan');

      await _supabase.from('detail_keranjang').insert({
        'keranjang_id': cart.id,
        'produk_id': produkId,
        'jumlah': jumlah,
        'harga_satuan': hargaSatuan,
      });
    } catch (e) {
      print('Error adding to cart: $e');
      rethrow;
    }
  }

  Future<void> updateCartItem(String detailKeranjangId, int jumlah) async {
    try {
      await _supabase
          .from('detail_keranjang')
          .update({'jumlah': jumlah})
          .eq('detail_keranjang_id', detailKeranjangId);
    } catch (e) {
      print('Error updating cart item: $e');
      rethrow;
    }
  }

  Future<void> removeFromCart(String detailKeranjangId) async {
    try {
      await _supabase
          .from('detail_keranjang')
          .delete()
          .eq('detail_keranjang_id', detailKeranjangId);
    } catch (e) {
      print('Error removing from cart: $e');
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      final cart = await getMyCart();
      if (cart == null) return;

      await _supabase
          .from('detail_keranjang')
          .delete()
          .eq('keranjang_id', cart.id);
    } catch (e) {
      print('Error clearing cart: $e');
      rethrow;
    }
  }
}
