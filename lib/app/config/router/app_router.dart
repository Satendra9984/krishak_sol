import 'package:bhoomi_sakti/features/splash/presentation/pages/splash.dart';
import 'package:bhoomi_sakti/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_route_paths.dart';

// Provider for GoRouter
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutePaths.home,
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Routes
      // TODO: Add login, signup, etc. routes here

      // Main App
      GoRoute(
        path: AppRoutePaths.home,
        builder: (context, state) => const DashboardScreen(),
        routes: [
          // Add nested routes here if needed
        ],
      ),
    ],
    // TODO: Add error handling, redirection, etc.
    // errorBuilder: (context, state) => ErrorScreen(error: state.error),
    // redirect: (context, state) {
    //   final loggedIn = ref.watch(authNotifierProvider).isAuthenticated;
    //   final loggingIn = state.matchedLocation == '/login';
    //   if (!loggedIn && !loggingIn) return '/login';
    //   if (loggedIn && loggingIn) return '/';
    //   return null;
    // },
  );
});
