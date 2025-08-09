import 'package:supabase_demo/features/coffee/domain/entities/coffee_log.dart';

abstract class CoffeeRepository {
  Future<List<CoffeeLog>> getCoffeeLogs();
  Future<List<CoffeeLog>> getTodayCoffeeLogs();
  Future<CoffeeLog> addCoffeeLog(double price);
} 