import 'package:flutter/foundation.dart';
import '../models/profile_model.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _error;
  String? _currentUserId;
  ProfileModel? _currentUser;
  String? _myRole;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentUserId => _currentUserId;
  ProfileModel? get currentUser => _currentUser;
  String? get myRole => _myRole;

  AuthController() {
    _currentUserId = _authService.currentUserId;
  }

  Future<void> register(
    String email,
    String password,
    String username,
    String role,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.register(email, password, username, role);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.login(email, password);
      _currentUserId = _authService.currentUserId;
      await fetchCurrentUserProfile();
      await fetchMyRole();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.logout();
      _currentUserId = null;
      _currentUser = null;
      _myRole = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchCurrentUserProfile() async {
    try {
      _currentUser = await _authService.getCurrentUserProfile();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchMyRole() async {
    try {
      _myRole = await _authService.getMyRole();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
