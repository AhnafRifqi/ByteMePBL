import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pembayaran_model.dart';

class PembayaranService {
  final _supabase = Supabase.instance.client;

  Future<PembayaranModel?> getPaymentByOrderId(String pesananId) async {
    try {
      final data = await _supabase
          .from('pembayaran')
          .select()
          .eq('pesanan_id', pesananId)
          .single();

      return PembayaranModel.fromMap(data);
    } catch (e) {
      print('Error getting payment: $e');
      return null;
    }
  }

  Future<String> createPayment(String pesananId, String metode) async {
    try {
      final result = await _supabase
          .from('pembayaran')
          .insert({
            'pesanan_id': pesananId,
            'metode': metode,
            'status': 'menunggu',
          })
          .select()
          .single();

      return result['pembayaran_id'];
    } catch (e) {
      print('Error creating payment: $e');
      rethrow;
    }
  }

  Future<void> updatePaymentStatus(String pembayaranId, String status) async {
    try {
      await _supabase
          .from('pembayaran')
          .update({
            'status': status,
            'tgl_bayar': status == 'berhasil'
                ? DateTime.now().toIso8601String()
                : null,
          })
          .eq('pembayaran_id', pembayaranId);
    } catch (e) {
      print('Error updating payment status: $e');
      rethrow;
    }
  }

  Future<List<PembayaranModel>> getMyPayments() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final data = await _supabase.rpc(
        'get_my_payments',
        params: {'p_user_id': userId},
      );

      return (data as List)
          .map((item) => PembayaranModel.fromMap(item))
          .toList();
    } catch (e) {
      print('Error getting payments: $e');
      // Fallback: fetch all orders then their payments
      return [];
    }
  }

  List<String> getPaymentMethods() {
    return ['transfer', 'cod', 'ewallet', 'kartu_kredit'];
  }
}
