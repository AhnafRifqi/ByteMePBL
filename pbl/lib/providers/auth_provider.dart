import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_model.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

final authStateProvider = StreamProvider<String?>((ref) {
  // Return user ID ketika login, null ketika logout
  return ref.read(authServiceProvider).authStream;
});

final currentUserProvider = FutureProvider<ProfileModel?>((ref) async {
  final authService = ref.read(authServiceProvider);
  final userId = authService.currentUserId;
  if (userId == null) return null;

  return await authService.getCurrentUserProfile();
});

final myRoleProvider = FutureProvider<String?>((ref) async {
  return await ref.read(authServiceProvider).getMyRole();
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AsyncValue.data(null));

  Future<void> register(
    String email,
    String password,
    String username,
    String role,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _authService.register(email, password, username, role),
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authService.login(email, password));
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authService.logout());
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
      final authService = ref.watch(authServiceProvider);
      return AuthNotifier(authService);
    });
