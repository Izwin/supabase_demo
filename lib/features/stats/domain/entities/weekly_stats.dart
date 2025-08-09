import 'package:equatable/equatable.dart';
import 'package:supabase_demo/features/stats/domain/entities/daily_stat.dart';

class WeeklyStats extends Equatable {
  final List<DailyStat> dailyStats;
  final int totalCups;
  final double totalSpent;

  const WeeklyStats({
    required this.dailyStats,
    required this.totalCups,
    required this.totalSpent,
  });

  @override
  List<Object?> get props => [dailyStats, totalCups, totalSpent];
} 