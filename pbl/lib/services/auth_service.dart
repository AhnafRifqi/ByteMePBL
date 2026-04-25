import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  Future<void> register(String email, String password, String username, String role) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'username': username, 'role': role},
    );
  }

  Future<void> login(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> logout() async => await _supabase.auth.signOut();

  String? get currentUserId => _supabase.auth.currentUser?.id;

  Future<String?> getMyRole() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    final data = await _supabase.from('profiles').select('role').eq('id', user.id).single();
    return data['role'];
  }
}