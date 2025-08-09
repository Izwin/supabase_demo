import 'package:supabase_demo/features/coffee/domain/entities/coffee_log.dart';
import 'package:supabase_demo/features/coffee/domain/repositories/coffee_repository.dart';

class GetTodayCoffeeLogsUseCase {
  final CoffeeRepository _coffeeRepository;

  GetTodayCoffeeLogsUseCase(this._coffeeRepository);

  Future<List<CoffeeLog>> call() {
    return _coffeeRepository.getTodayCoffeeLogs();
  }
} 