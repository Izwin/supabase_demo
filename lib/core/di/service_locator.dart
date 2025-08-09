import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_demo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:supabase_demo/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_demo/features/auth/domain/usecases/login_usecase.dart';
import 'package:supabase_demo/features/auth/domain/usecases/logout_usecase.dart';
import 'package:supabase_demo/features/auth/domain/usecases/register_usecase.dart';
import 'package:supabase_demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_demo/features/coffee/data/datasources/coffee_remote_datasource.dart';
import 'package:supabase_demo/features/coffee/data/repositories/coffee_repository_impl.dart';
import 'package:supabase_demo/features/coffee/domain/repositories/coffee_repository.dart';
import 'package:supabase_demo/features/coffee/domain/usecases/add_coffee_log_usecase.dart';
import 'package:supabase_demo/features/coffee/domain/usecases/get_coffee_logs_usecase.dart';
import 'package:supabase_demo/features/coffee/domain/usecases/get_today_coffee_logs_usecase.dart';
import 'package:supabase_demo/features/coffee/presentation/bloc/coffee_bloc.dart';
import 'package:supabase_demo/features/stats/data/repositories/stats_repository_impl.dart';
import 'package:supabase_demo/features/stats/domain/repositories/stats_repository.dart';
import 'package:supabase_demo/features/stats/domain/usecases/get_weekly_stats_usecase.dart';
import 'package:supabase_demo/features/stats/presentation/bloc/stats_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External
  final supabase = Supabase.instance.client;
  getIt.registerLazySingleton<SupabaseClient>(() => supabase);

  // Data sources
  getIt.registerLazySingleton<CoffeeRemoteDataSource>(
    () => CoffeeRemoteDataSourceImpl(getIt<SupabaseClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<SupabaseClient>()),
  );
  
  getIt.registerLazySingleton<CoffeeRepository>(
    () => CoffeeRepositoryImpl(getIt<CoffeeRemoteDataSource>()),
  );
  
  getIt.registerLazySingleton<StatsRepository>(
    () => StatsRepositoryImpl(getIt<SupabaseClient>()),
  );

  // Use cases
  // Auth
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  
  // Coffee
  getIt.registerLazySingleton(() => AddCoffeeLogUseCase(getIt<CoffeeRepository>()));
  getIt.registerLazySingleton(() => GetCoffeeLogsUseCase(getIt<CoffeeRepository>()));
  getIt.registerLazySingleton(() => GetTodayCoffeeLogsUseCase(getIt<CoffeeRepository>()));
  
  // Stats
  getIt.registerLazySingleton(() => GetWeeklyStatsUseCase(getIt<StatsRepository>()));

  // BLoCs
  getIt.registerFactory(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
    ),
  );
  
  getIt.registerFactory(
    () => CoffeeBloc(
      addCoffeeLogUseCase: getIt<AddCoffeeLogUseCase>(),
      getCoffeeLogsUseCase: getIt<GetCoffeeLogsUseCase>(),
      getTodayCoffeeLogsUseCase: getIt<GetTodayCoffeeLogsUseCase>(),
    ),
  );
  
  getIt.registerFactory(
    () => StatsBloc(
      getWeeklyStatsUseCase: getIt<GetWeeklyStatsUseCase>(),
    ),
  );
} 