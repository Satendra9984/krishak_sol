import 'package:bhoomi_sakti/features/splash/presentation/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for GoRouter
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder:
            (context, state) =>
                const SplashScreen(), // Replace with your actual initial screen
        // TODO: Add more routes for different features/modules
        // Example:
        // routes: [
        //   GoRoute(
        //     path: 'auth',
        //     builder: (context, state) => const LoginPage(),
        //   ),
        // ],
      ),
      // Example for a feature route (e.g., farmer module)
      // GoRoute(
      //   path: '/farmer',
      //   builder: (context, state) => const FarmerDashboardScreen(),
      //   routes: [
      //     GoRoute(
      //       path: 'soil-test-request',
      //       builder: (context, state) => const SoilTestRequestScreen(),
      //     ),
      //   ]
      // ),
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

// TODO: Define your route paths here for better management
// class AppRoutes {
//   static const String splash = '/';
//   static const String login = '/login';
//   static const String farmerDashboard = '/farmer';
//   static const String soilTestRequest = '/farmer/soil-test-request';
// }
