import 'package:equatable/equatable.dart';

class DailyStat extends Equatable {
  final DateTime date;
  final int cups;
  final double spent;

  const DailyStat({
    required this.date,
    required this.cups,
    required this.spent,
  });

  @override
  List<Object?> get props => [date, cups, spent];
} 