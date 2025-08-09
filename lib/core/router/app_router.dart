import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_demo/features/auth/presentation/screens/login_screen.dart';
import 'package:supabase_demo/features/auth/presentation/screens/register_screen.dart';
import 'package:supabase_demo/features/auth/presentation/screens/confirm_email_screen.dart';
import 'package:supabase_demo/features/coffee/presentation/screens/home_screen.dart';
import 'package:supabase_demo/features/stats/presentation/screens/stats_screen.dart';
import 'package:supabase_demo/features/profile/presentation/screens/profile_screen.dart';
import 'package:supabase_demo/core/widgets/main_scaffold.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: LoginScreen.routePath,
    redirect: (BuildContext context, GoRouterState state) {
      final User? currentUser = Supabase.instance.client.auth.currentUser;
      final bool isAuthenticated = currentUser != null;
      
      final isAuthRoute = state.matchedLocation == LoginScreen.routePath || 
                          state.matchedLocation == RegisterScreen.routePath || 
                          state.matchedLocation == ConfirmEmailScreen.routePath ||
                          state.matchedLocation == '/';

      if (!isAuthenticated && !isAuthRoute) {
        return LoginScreen.routePath;
      }
      if (isAuthenticated && isAuthRoute) {
        return HomeScreen.routePath;
      }

      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/',
        redirect: (_, __) => LoginScreen.routePath,
      ),
      GoRoute(
        path: LoginScreen.routePath,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RegisterScreen.routePath,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: ConfirmEmailScreen.routePath,
        builder: (context, state) => const ConfirmEmailScreen(),
      ),

      StatefulShellRoute.indexedStack(branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: HomeScreen.routePath,
            builder: (context, state) => const HomeScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: StatsScreen.routePath,
            builder: (context, state) => const StatsScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: ProfileScreen.routePath,
            builder: (context, state) => const ProfileScreen(),
          ),
        ])
      ],builder: (context,state, child){
        return MainScaffold(statefulNavigationShell: child,);
      }),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Route not found')),
    ),
  );
} 