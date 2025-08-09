import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_demo/features/coffee/domain/entities/coffee_log.dart';
import 'package:supabase_demo/features/coffee/domain/usecases/add_coffee_log_usecase.dart';
import 'package:supabase_demo/features/coffee/domain/usecases/get_coffee_logs_usecase.dart';
import 'package:supabase_demo/features/coffee/domain/usecases/get_today_coffee_logs_usecase.dart';

part 'coffee_event.dart';
part 'coffee_state.dart';

class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {
  final AddCoffeeLogUseCase addCoffeeLogUseCase;
  final GetCoffeeLogsUseCase getCoffeeLogsUseCase;
  final GetTodayCoffeeLogsUseCase getTodayCoffeeLogsUseCase;

  CoffeeBloc({
    required this.addCoffeeLogUseCase,
    required this.getCoffeeLogsUseCase,
    required this.getTodayCoffeeLogsUseCase,
  }) : super(CoffeeInitial()) {
    on<LoadCoffeeLogsEvent>(_onLoadCoffeeLogs);
    on<LoadTodayCoffeeLogsEvent>(_onLoadTodayCoffeeLogs);
    on<AddCoffeeLogEvent>(_onAddCoffeeLog);
  }

  Future<void> _onLoadCoffeeLogs(
    LoadCoffeeLogsEvent event,
    Emitter<CoffeeState> emit,
  ) async {
    emit(CoffeeLoading());
    try {
      final coffeeLogs = await getCoffeeLogsUseCase();
      emit(CoffeeLoaded(coffeeLogs));
    } catch (e) {
      emit(CoffeeError(e.toString()));
    }
  }

  Future<void> _onLoadTodayCoffeeLogs(
    LoadTodayCoffeeLogsEvent event,
    Emitter<CoffeeState> emit,
  ) async {
    emit(CoffeeLoading());
    try {
      final todayCoffeeLogs = await getTodayCoffeeLogsUseCase();
      
      // Calculate total spent today
      final totalSpentToday = todayCoffeeLogs.fold<double>(
        0, (sum, log) => sum + log.price);
      
      emit(TodayCoffeeLoaded(
        todayCoffeeLogs,
        todayCoffeeLogs.length,
        totalSpentToday,
      ));
    } catch (e) {
      emit(CoffeeError(e.toString()));
    }
  }

  Future<void> _onAddCoffeeLog(
    AddCoffeeLogEvent event,
    Emitter<CoffeeState> emit,
  ) async {
    final currentState = state;
    emit(CoffeeLoading());
    try {
      final newCoffeeLog = await addCoffeeLogUseCase(event.price);
      
      // If we were showing today's logs, refresh them
      if (currentState is TodayCoffeeLoaded) {
        add(LoadTodayCoffeeLogsEvent());
      } else {
        add(LoadCoffeeLogsEvent());
      }
      
      emit(CoffeeLogAdded(newCoffeeLog));
    } catch (e) {
      emit(CoffeeError(e.toString()));
    }
  }
} 