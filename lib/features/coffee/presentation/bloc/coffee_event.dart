part of 'coffee_bloc.dart';

abstract class CoffeeEvent extends Equatable {
  const CoffeeEvent();

  @override
  List<Object?> get props => [];
}

class LoadCoffeeLogsEvent extends CoffeeEvent {}

class LoadTodayCoffeeLogsEvent extends CoffeeEvent {}

class AddCoffeeLogEvent extends CoffeeEvent {
  final double price;

  const AddCoffeeLogEvent(this.price);

  @override
  List<Object?> get props => [price];
} 