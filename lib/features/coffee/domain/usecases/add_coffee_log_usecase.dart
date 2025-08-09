import 'package:supabase_demo/features/coffee/domain/entities/coffee_log.dart';
import 'package:supabase_demo/features/coffee/domain/repositories/coffee_repository.dart';

class AddCoffeeLogUseCase {
  final CoffeeRepository _coffeeRepository;

  AddCoffeeLogUseCase(this._coffeeRepository);

  Future<CoffeeLog> call(double price) {
    return _coffeeRepository.addCoffeeLog(price);
  }
} 