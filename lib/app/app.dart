import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_demo/core/theme/app_theme.dart';
import 'package:supabase_demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_demo/features/coffee/presentation/bloc/coffee_bloc.dart';
import 'package:supabase_demo/features/stats/presentation/bloc/stats_bloc.dart';
import 'package:supabase_demo/core/di/service_locator.dart';
import 'package:supabase_demo/core/router/app_router.dart';

class CoffeeTrackerApp extends StatelessWidget {
  const CoffeeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider<CoffeeBloc>(
          create: (context) => getIt<CoffeeBloc>(),
        ),
        BlocProvider<StatsBloc>(
          create: (context) => getIt<StatsBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Coffee Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
} 