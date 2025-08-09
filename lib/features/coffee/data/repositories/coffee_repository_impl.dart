import 'package:supabase_demo/features/coffee/data/datasources/coffee_remote_datasource.dart';
import 'package:supabase_demo/features/coffee/domain/entities/coffee_log.dart';
import 'package:supabase_demo/features/coffee/domain/repositories/coffee_repository.dart';

class CoffeeRepositoryImpl implements CoffeeRepository {
  final CoffeeRemoteDataSource _remoteDataSource;

  CoffeeRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<CoffeeLog>> getCoffeeLogs() async {
    final coffeeLogModels = await _remoteDataSource.getCoffeeLogs();
    return coffeeLogModels;
  }

  @override
  Future<List<CoffeeLog>> getTodayCoffeeLogs() async {
    final coffeeLogModels = await _remoteDataSource.getTodayCoffeeLogs();
    return coffeeLogModels;
  }

  @override
  Future<CoffeeLog> addCoffeeLog(double price) async {
    final coffeeLogModel = await _remoteDataSource.addCoffeeLog(price);
    return coffeeLogModel;
  }
} 