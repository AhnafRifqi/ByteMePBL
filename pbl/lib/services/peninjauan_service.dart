import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/peninjauan_model.dart';
import '../models/sanksi_akun_model.dart';

class PeninjaauanService {
  final _supabase = Supabase.instance.client;

  Future<List<PeninjaauanModel>> getAllReviews() async {
    try {
      // Only admin can fetch
      final role = await _getMyRole();
      if (role != 'admin') throw Exception('Hanya admin yang dapat akses');

      final data = await _supabase
          .from('peninjauan')
          .select()
          .order('peninjauan_id', ascending: false);

      return (data as List)
          .map((item) => PeninjaauanModel.fromMap(item))
          .toList();
    } catch (e) {
      print('Error getting reviews: $e');
      return [];
    }
  }

  Future<PeninjaauanModel?> getReviewById(String peninjaauanId) async {
    try {
      final data = await _supabase
          .from('peninjauan')
          .select()
          .eq('peninjauan_id', peninjaauanId)
          .single();

      return PeninjaauanModel.fromMap(data);
    } catch (e) {
      print('Error getting review: $e');
      return null;
    }
  }

  Future<void> createReview(
    String userId,
    String produkId,
    String? catatan,
  ) async {
    try {
      final role = await _getMyRole();
      if (role != 'admin')
        throw Exception('Hanya admin yang dapat membuat peninjauan');

      await _supabase.from('peninjauan').insert({
        'user_id': userId,
        'produk_id': produkId,
        'catatan': catatan,
        'status': 'proses',
      });
    } catch (e) {
      print('Error creating review: $e');
      rethrow;
    }
  }

  Future<void> updateReviewStatus(String peninjaauanId, String status) async {
    try {
      final role = await _getMyRole();
      if (role != 'admin') throw Exception('Hanya admin yang dapat update');

      await _supabase
          .from('peninjauan')
          .update({'status': status})
          .eq('peninjauan_id', peninjaauanId);
    } catch (e) {
      print('Error updating review: $e');
      rethrow;
    }
  }

  Future<void> issueWarning(
    String peninjaauanId,
    String userId,
    String alasan,
  ) async {
    try {
      await _supabase.from('sanksi_akun').insert({
        'peninjauan_id': peninjaauanId,
        'user_id': userId,
        'jenis': 'peringatan',
        'alasan': alasan,
      });
    } catch (e) {
      print('Error issuing warning: $e');
      rethrow;
    }
  }

  Future<void> issueSuspension(
    String peninjaauanId,
    String userId,
    String alasan,
  ) async {
    try {
      await _supabase.from('sanksi_akun').insert({
        'peninjauan_id': peninjaauanId,
        'user_id': userId,
        'jenis': 'suspensi',
        'alasan': alasan,
      });
    } catch (e) {
      print('Error issuing suspension: $e');
      rethrow;
    }
  }

  Future<void> issueBan(
    String peninjaauanId,
    String userId,
    String alasan,
  ) async {
    try {
      await _supabase.from('sanksi_akun').insert({
        'peninjauan_id': peninjaauanId,
        'user_id': userId,
        'jenis': 'banned',
        'alasan': alasan,
      });
    } catch (e) {
      print('Error issuing ban: $e');
      rethrow;
    }
  }

  Future<String?> _getMyRole() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;
      final data = await _supabase
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .single();
      return data['role'];
    } catch (e) {
      return null;
    }
  }
}
