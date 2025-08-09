import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_demo/features/stats/domain/entities/weekly_stats.dart';
import 'package:supabase_demo/features/stats/domain/usecases/get_weekly_stats_usecase.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final GetWeeklyStatsUseCase getWeeklyStatsUseCase;

  StatsBloc({
    required this.getWeeklyStatsUseCase,
  }) : super(StatsInitial()) {
    on<LoadWeeklyStatsEvent>(_onLoadWeeklyStats);
  }

  Future<void> _onLoadWeeklyStats(
    LoadWeeklyStatsEvent event,
    Emitter<StatsState> emit,
  ) async {
    emit(StatsLoading());
    try {
      final weeklyStats = await getWeeklyStatsUseCase();
      emit(StatsLoaded(weeklyStats));
    } catch (e) {
      emit(StatsError(e.toString()));
    }
  }
} 