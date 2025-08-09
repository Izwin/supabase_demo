import 'package:supabase_demo/features/stats/domain/entities/weekly_stats.dart';

abstract class StatsRepository {
  Future<WeeklyStats> getWeeklyStats();
} 