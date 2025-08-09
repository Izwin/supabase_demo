import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_demo/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<User> call(String email, String password) {
    return _authRepository.login(email, password);
  }
} 