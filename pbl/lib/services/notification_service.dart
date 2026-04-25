import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final _supabase = Supabase.instance.client;

  // Mengambil stream notifikasi (dipakai di widget NotifikasiListener)
  Stream<List<Map<String, dynamic>>> streamNotifikasi() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return const Stream.empty();

    return _supabase
        .from('notifikasi')
        .stream(primaryKey: ['notif_id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false);
  }

  // Menandai notifikasi sebagai "dibaca" agar tidak muncul terus
  Future<void> tandaiDibaca(String notifId) async {
    await _supabase
        .from('notifikasi')
        .update({'status': 'dibaca'})
        .eq('notif_id', notifId);
  }
}