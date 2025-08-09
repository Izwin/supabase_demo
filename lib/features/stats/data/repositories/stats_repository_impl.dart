import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_demo/features/stats/domain/entities/daily_stat.dart';
import 'package:supabase_demo/features/stats/domain/entities/weekly_stats.dart';
import 'package:supabase_demo/features/stats/domain/repositories/stats_repository.dart';

class StatsRepositoryImpl implements StatsRepository {
  final SupabaseClient _supabaseClient;

  StatsRepositoryImpl(this._supabaseClient);

  @override
  Future<WeeklyStats> getWeeklyStats() async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final startDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final endDate = startDate.add(const Duration(days: 7));

    final response = await _supabaseClient
        .from('coffee_logs')
        .select()
        .eq('user_id', user.id)
        .gte('timestamp', startDate.toIso8601String())
        .lt('timestamp', endDate.toIso8601String())
        .order('timestamp');

    final logs = (response as List<dynamic>).map((json) {
      return {
        'timestamp': DateTime.parse(json['timestamp'] as String),
        'price': (json['price'] as num).toDouble(),
      };
    }).toList();

    // Group logs by day
    final Map<String, List<Map<String, dynamic>>> groupedByDay = {};
    for (final log in logs) {
      final date = log['timestamp'] as DateTime;
      final day = DateTime(date.year, date.month, date.day).toIso8601String();
      
      if (!groupedByDay.containsKey(day)) {
        groupedByDay[day] = [];
      }
      
      groupedByDay[day]!.add(log);
    }

    // Create daily stats
    final List<DailyStat> dailyStats = [];
    double totalSpent = 0;
    int totalCups = 0;

    for (int i = 0; i < 7; i++) {
      final date = startDate.add(Duration(days: i));
      final day = DateTime(date.year, date.month, date.day).toIso8601String();
      
      final dayLogs = groupedByDay[day] ?? [];
      final cups = dayLogs.length;
      final spent = dayLogs.fold<double>(
        0, (sum, log) => sum + (log['price'] as double));
      
      totalCups += cups;
      totalSpent += spent;
      
      dailyStats.add(DailyStat(
        date: date,
        cups: cups,
        spent: spent,
      ));
    }

    return WeeklyStats(
      dailyStats: dailyStats,
      totalCups: totalCups,
      totalSpent: totalSpent,
    );
  }
} 