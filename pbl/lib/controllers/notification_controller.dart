import 'package:flutter/foundation.dart';
import '../models/notifikasi_model.dart';
import '../services/notifikasi_service.dart';

class NotificationController extends ChangeNotifier {
  final NotifikasiService _notifikasiService = NotifikasiService();

  bool _isLoading = false;
  String? _error;
  List<NotifikasiModel> _myNotifications = [];
  int _unreadCount = 0;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<NotifikasiModel> get myNotifications => _myNotifications;
  int get unreadCount => _unreadCount;

  Future<void> fetchMyNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _myNotifications = await _notifikasiService.getMyNotifications();
      await _fetchUnreadCount();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchUnreadCount() async {
    try {
      _unreadCount = await _notifikasiService.getUnreadCount();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> markAsRead(String notifikasiId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _notifikasiService.markAsRead(notifikasiId);
      await fetchMyNotifications();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> markAllAsRead() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _notifikasiService.markAllAsRead();
      await fetchMyNotifications();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteNotification(String notifikasiId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _notifikasiService.deleteNotification(notifikasiId);
      await fetchMyNotifications();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
