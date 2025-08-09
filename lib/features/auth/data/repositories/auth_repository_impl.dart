import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_demo/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabaseClient;

  AuthRepositoryImpl(this._supabaseClient);

  @override
  Future<User?> getCurrentUser() async {
    return _supabaseClient.auth.currentUser;
  }

  @override
  Future<User> login(String email, String password) async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    
    if (response.user == null) {
      throw Exception('Login failed');
    }
    
    return response.user!;
  }

  @override
  Future<User> register(String email, String password) async {
    final response = await _supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
    
    if (response.user == null) {
      throw Exception('Registration failed');
    }
    
    return response.user!;
  }

  @override
  Future<void> logout() async {
    await _supabaseClient.auth.signOut();
  }
} 