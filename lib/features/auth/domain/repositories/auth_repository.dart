import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<User> login(String email, String password);
  Future<User> register(String email, String password);
  Future<void> logout();
} 