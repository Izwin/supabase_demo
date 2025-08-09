import 'package:equatable/equatable.dart';

class CoffeeLog extends Equatable {
  final String id;
  final String userId;
  final DateTime timestamp;
  final double price;

  const CoffeeLog({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.price,
  });

  @override
  List<Object?> get props => [id, userId, timestamp, price];
} 