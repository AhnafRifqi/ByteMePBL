import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notifikasi_model.dart';
import '../services/notifikasi_service.dart';

final notifikasiServiceProvider = Provider((ref) => NotifikasiService());

final myNotificationsProvider = FutureProvider<List<NotifikasiModel>>((
  ref,
) async {
  return await ref.read(notifikasiServiceProvider).getMyNotifications();
});

final unreadCountProvider = FutureProvider<int>((ref) async {
  return await ref.read(notifikasiServiceProvider).getUnreadCount();
});

class NotificationNotifier extends StateNotifier<AsyncValue<void>> {
  final NotifikasiService _notifikasiService;
  final Ref _ref;

  NotificationNotifier(this._notifikasiService, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> markAsRead(String notifikasiId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _notifikasiService.markAsRead(notifikasiId),
    );

    _ref.refresh(myNotificationsProvider);
    _ref.refresh(unreadCountProvider);
  }

  Future<void> markAllAsRead() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _notifikasiService.markAllAsRead());

    _ref.refresh(myNotificationsProvider);
    _ref.refresh(unreadCountProvider);
  }

  Future<void> deleteNotification(String notifikasiId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _notifikasiService.deleteNotification(notifikasiId),
    );

    _ref.refresh(myNotificationsProvider);
  }
}

final notificationNotifierProvider =
    StateNotifierProvider<NotificationNotifier, AsyncValue<void>>((ref) {
      final notifikasiService = ref.watch(notifikasiServiceProvider);
      return NotificationNotifier(notifikasiService, ref);
    });
