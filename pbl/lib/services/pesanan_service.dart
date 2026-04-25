import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pesanan_model.dart';
import '../models/detail_pesanan_model.dart';

class PesananService {
  final _supabase = Supabase.instance.client;

  Future<List<PesananModel>> getMyOrders() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final data = await _supabase
          .from('pesanan')
          .select()
          .eq('user_id', userId)
          .order('tgl_pesanan', ascending: false);

      return (data as List).map((item) => PesananModel.fromMap(item)).toList();
    } catch (e) {
      print('Error getting orders: $e');
      return [];
    }
  }

  Future<PesananModel?> getOrderById(String pesananId) async {
    try {
      final data = await _supabase
          .from('pesanan')
          .select()
          .eq('pesanan_id', pesananId)
          .single();

      return PesananModel.fromMap(data);
    } catch (e) {
      print('Error getting order: $e');
      return null;
    }
  }

  Future<List<DetailPesananModel>> getOrderDetails(String pesananId) async {
    try {
      final data = await _supabase
          .from('detail_pesanan')
          .select()
          .eq('pesanan_id', pesananId);

      return (data as List)
          .map((item) => DetailPesananModel.fromMap(item))
          .toList();
    } catch (e) {
      print('Error getting order details: $e');
      return [];
    }
  }

  Future<String> createOrder(
    List<Map<String, dynamic>> items,
    double totalHarga,
  ) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User tidak login');

      // Create pesanan
      final pesananResult = await _supabase
          .from('pesanan')
          .insert({
            'user_id': userId,
            'total_harga': totalHarga,
            'status': 'menunggu',
          })
          .select()
          .single();

      final pesananId = pesananResult['pesanan_id'];

      // Create detail_pesanan
      for (var item in items) {
        await _supabase.from('detail_pesanan').insert({
          'pesanan_id': pesananId,
          'produk_id': item['produk_id'],
          'jumlah': item['jumlah'],
          'harga_satuan': item['harga_satuan'],
        });
      }

      return pesananId;
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  Future<void> cancelOrder(String pesananId) async {
    try {
      await _supabase
          .from('pesanan')
          .update({'status': 'dibatalkan'})
          .eq('pesanan_id', pesananId);
    } catch (e) {
      print('Error canceling order: $e');
      rethrow;
    }
  }

  Future<void> updateOrderStatus(String pesananId, String status) async {
    try {
      await _supabase
          .from('pesanan')
          .update({'status': status})
          .eq('pesanan_id', pesananId);
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }
}
