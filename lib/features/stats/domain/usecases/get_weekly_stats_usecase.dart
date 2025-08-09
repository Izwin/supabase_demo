import 'package:supabase_demo/features/stats/domain/entities/weekly_stats.dart';
import 'package:supabase_demo/features/stats/domain/repositories/stats_repository.dart';

class GetWeeklyStatsUseCase {
  final StatsRepository _statsRepository;

  GetWeeklyStatsUseCase(this._statsRepository);

  Future<WeeklyStats> call() {
    return _statsRepository.getWeeklyStats();
  }
} 