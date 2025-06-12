import 'package:bhoomi_sakti/common/app_common_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/app/core/providers/shared_preferences_provider.dart';
import 'package:bhoomi_sakti/features/splash/presentation/providers/splash_providers.dart';
import 'package:bhoomi_sakti/features/splash/presentation/pages/splash.dart';
import 'package:bhoomi_sakti/features/dashboard/presentation/pages/dashboard_screen.dart';

import 'package:bhoomi_sakti/features/authentication/auth_routes.dart';
import 'package:bhoomi_sakti/common/providers/auth_notifier/auth_state.dart';
import 'package:bhoomi_sakti/features/onboarding/onboarding_providers.dart'
    as onboarding_providers;
import 'package:bhoomi_sakti/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bhoomi_sakti/features/onboarding/presentation/pages/onboarding_page.dart';

import 'app_route_paths.dart';

// Provider for GoRouter
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutePaths.splash, // Start with splash to check auth
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutePaths.splash,
        builder:
            (context, state) => BlocProvider.value(
              value: ref.read(splashBlocProvider),
              child: const SplashScreen(),
            ),
      ),

      // Onboarding Route
      GoRoute(
        path: AppRoutePaths.onboarding,
        name: AppRoutePaths.onboarding,
        builder:
            (context, state) => ProviderScope(
              overrides: [
                onboarding_providers.onboardingBlocProvider.overrideWithValue(
                  OnboardingBloc(
                    sharedPreferences: ref.read(sharedPreferencesProvider),
                  )..add(OnboardingStarted()),
                ),
              ],
              child: const OnboardingPage(),
            ),
      ),

      // Auth Routes
      ...getAuthRoutes(ref),

      // Main App
      GoRoute(
        path: AppRoutePaths.home,
        builder: (context, state) => const DashboardScreen(),
        routes: [
          // Add nested routes here if needed
        ],
      ),
    ],
    // errorBuilder: (context, state) => ErrorScreen(error: state.error),
    //// TODO: Implement ErrorScreen
    redirect: (BuildContext context, GoRouterState state) async {
      final prefs = await ref.read(sharedPreferencesInitializerProvider.future);
      final bool isBoardingComplete = await OnboardingBloc.isOnboardingComplete(
        prefs,
      );
      final bool onOnboardingScreen =
          state.matchedLocation == AppRoutePaths.onboarding;

      // If onboarding is not complete, redirect to onboarding screen
      if (!isBoardingComplete) {
        return onOnboardingScreen ? null : AppRoutePaths.onboarding;
      }

      // If onboarding is complete, proceed with auth checks
      final authState = ref.watch(authNotifierProvider);
      final loggingIn =
          state.matchedLocation == AppRoutePaths.login ||
          state.matchedLocation == AppRoutePaths.signUp ||
          state.matchedLocation == AppRoutePaths.otpVerification;

      final splashing = state.matchedLocation == AppRoutePaths.splash;

      if (authState is AuthInitial || authState is AuthLoading) {
        return splashing
            ? null
            : AppRoutePaths
                .splash; // Stay on splash or go to splash if not already there
      }

      if (authState is Unauthenticated) {
        // If unauthenticated and not on splash, auth pages, or onboarding (which is now handled),
        // redirect to login.
        return (loggingIn || splashing || onOnboardingScreen)
            ? null
            : AppRoutePaths.login;
      }

      if (authState is Authenticated) {
        // If authenticated and on splash, login, signup, otp, or onboarding, redirect to home
        if (splashing || loggingIn || onOnboardingScreen) {
          return AppRoutePaths.home;
        }
      }

      // For AuthFailureState, decide if you want to redirect or show error on current page
      // if (authState is AuthFailureState) {
      //   return '/error'; // Or handle inline
      // }

      return null; // No redirect needed
    },
  );
});
