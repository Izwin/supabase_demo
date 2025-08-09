part of 'coffee_bloc.dart';

abstract class CoffeeState extends Equatable {
  const CoffeeState();

  @override
  List<Object?> get props => [];
}

class CoffeeInitial extends CoffeeState {}

class CoffeeLoading extends CoffeeState {}

class CoffeeLoaded extends CoffeeState {
  final List<CoffeeLog> coffeeLogs;

  const CoffeeLoaded(this.coffeeLogs);

  @override
  List<Object?> get props => [coffeeLogs];
}

class TodayCoffeeLoaded extends CoffeeState {
  final List<CoffeeLog> todayCoffeeLogs;
  final int cupsToday;
  final double totalSpentToday;

  const TodayCoffeeLoaded(
    this.todayCoffeeLogs,
    this.cupsToday,
    this.totalSpentToday,
  );

  @override
  List<Object?> get props => [todayCoffeeLogs, cupsToday, totalSpentToday];
}

class CoffeeLogAdded extends CoffeeState {
  final CoffeeLog coffeeLog;

  const CoffeeLogAdded(this.coffeeLog);

  @override
  List<Object?> get props => [coffeeLog];
}

class CoffeeError extends CoffeeState {
  final String message;

  const CoffeeError(this.message);

  @override
  List<Object?> get props => [message];
} 