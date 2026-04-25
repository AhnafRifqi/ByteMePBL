import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notifikasi_model.dart';

class NotifikasiService {
  final _supabase = Supabase.instance.client;

  Future<List<NotifikasiModel>> getMyNotifications() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final data = await _supabase
          .from('notifikasi')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (data as List)
          .map((item) => NotifikasiModel.fromMap(item))
          .toList();
    } catch (e) {
      print('Error getting notifications: $e');
      return [];
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return 0;

      final data = await _supabase
          .from('notifikasi')
          .select()
          .eq('user_id', userId)
          .eq('status', 'belum_dibaca');

      return (data as List).length;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  Future<void> markAsRead(String notifikasiId) async {
    try {
      await _supabase
          .from('notifikasi')
          .update({'status': 'dibaca'})
          .eq('notif_id', notifikasiId);
    } catch (e) {
      print('Error marking notification as read: $e');
      rethrow;
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      await _supabase
          .from('notifikasi')
          .update({'status': 'dibaca'})
          .eq('user_id', userId)
          .eq('status', 'belum_dibaca');
    } catch (e) {
      print('Error marking all as read: $e');
      rethrow;
    }
  }

  Future<void> deleteNotification(String notifikasiId) async {
    try {
      await _supabase.from('notifikasi').delete().eq('notif_id', notifikasiId);
    } catch (e) {
      print('Error deleting notification: $e');
      rethrow;
    }
  }

  // Real-time subscription untuk notifikasi
  void subscribeToNotifications(Function(NotifikasiModel) onNewNotification) {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    _supabase.from('notifikasi').on(RealtimeListenTypes.all, (payload) {
      try {
        if (payload.eventType == 'INSERT') {
          final data = NotifikasiModel.fromMap(payload.newRecord);
          if (data.userId == userId) {
            onNewNotification(data);
          }
        }
      } catch (e) {
        print('Error in subscription: $e');
      }
    }).subscribe();
  }
}
