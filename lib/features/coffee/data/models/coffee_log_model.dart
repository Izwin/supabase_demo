import 'package:supabase_demo/features/coffee/domain/entities/coffee_log.dart';

class CoffeeLogModel extends CoffeeLog {
  const CoffeeLogModel({
    required String id,
    required String userId,
    required DateTime timestamp,
    required double price,
  }) : super(
          id: id,
          userId: userId,
          timestamp: timestamp,
          price: price,
        );

  factory CoffeeLogModel.fromJson(Map<String, dynamic> json) {
    return CoffeeLogModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
      'price': price,
    };
  }

  factory CoffeeLogModel.fromEntity(CoffeeLog coffeeLog) {
    return CoffeeLogModel(
      id: coffeeLog.id,
      userId: coffeeLog.userId,
      timestamp: coffeeLog.timestamp,
      price: coffeeLog.price,
    );
  }
} 