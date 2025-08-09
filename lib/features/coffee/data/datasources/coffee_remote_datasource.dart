import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_demo/features/coffee/data/models/coffee_log_model.dart';

abstract class CoffeeRemoteDataSource {
  Future<List<CoffeeLogModel>> getCoffeeLogs();
  Future<List<CoffeeLogModel>> getTodayCoffeeLogs();
  Future<CoffeeLogModel> addCoffeeLog(double price);
}

class CoffeeRemoteDataSourceImpl implements CoffeeRemoteDataSource {
  final SupabaseClient _supabaseClient;

  CoffeeRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<List<CoffeeLogModel>> getCoffeeLogs() async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final response = await _supabaseClient
        .from('coffee_logs')
        .select()
        .eq('user_id', user.id)
        .order('timestamp', ascending: false);

    return (response as List<dynamic>)
        .map((json) => CoffeeLogModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CoffeeLogModel>> getTodayCoffeeLogs() async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final response = await _supabaseClient
        .from('coffee_logs')
        .select()
        .eq('user_id', user.id)
        .gte('timestamp', today.toIso8601String())
        .lt('timestamp', tomorrow.toIso8601String())
        .order('timestamp', ascending: false);

    return (response as List<dynamic>)
        .map((json) => CoffeeLogModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CoffeeLogModel> addCoffeeLog(double price) async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final now = DateTime.now();
    final data = {
      'user_id': user.id,
      'timestamp': now.toIso8601String(),
      'price': price,
    };

    final response = await _supabaseClient
        .from('coffee_logs')
        .insert(data)
        .select()
        .single();

    return CoffeeLogModel.fromJson(response);
  }
} 