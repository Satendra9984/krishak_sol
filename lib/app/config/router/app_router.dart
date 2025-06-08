import 'package:bhoomi_sakti/features/splash/presentation/pages/splash.dart';
import 'package:bhoomi_sakti/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/features/auth/auth_providers.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/auth_notifier/auth_state.dart';
import 'package:flutter/material.dart'; // For placeholder screens
import 'app_route_paths.dart';
import 'package:bhoomi_sakti/features/auth/presentation/pages/login_page.dart'; // Added LoginPage import
import 'package:bhoomi_sakti/features/auth/presentation/pages/onboarding_page.dart'; // Added OnboardingPage import
import 'package:bhoomi_sakti/features/auth/presentation/blocs/onboarding_bloc.dart'; // For OnboardingBloc.isOnboardingComplete
import 'package:bhoomi_sakti/features/auth/presentation/pages/otp_verification_page.dart'; // Added OtpVerificationPage import
import 'package:bhoomi_sakti/features/auth/presentation/pages/signup_page.dart'; // Added SignupPage import



// Provider for GoRouter
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutePaths.splash, // Start with splash to check auth
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding Route
      GoRoute(
        path: AppRoutePaths.onboarding,
        name: AppRoutePaths.onboarding, // Optional: for named navigation
        builder: (context, state) => const OnboardingPage(),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        name: AppRoutePaths.login, // Assuming login path is defined in AppRoutePaths
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        name: AppRoutePaths.signUp, // Corrected to match AppRoutePaths.signUp
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: AppRoutePaths.otpVerification, // Use constant for path
        name: AppRoutePaths.otpVerification,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final mobileNumber = extra?['mobileNumber'] as String?;
          final flowType = extra?['flowType'] as OtpFlowType?;

          if (mobileNumber == null || flowType == null) {
            // Handle missing parameters, e.g., redirect to login or show error
            // For now, redirecting to login as a fallback.
            // Consider a dedicated error screen or logging for production.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error: OTP verification details missing. Redirecting.')),
              );
              context.go(AppRoutePaths.login);
            });
            return const Scaffold(body: Center(child: CircularProgressIndicator())); // Placeholder while redirecting
          }
          return OtpVerificationPage(mobileNumber: mobileNumber, flowType: flowType);
        },
      ),

      // Main App
      GoRoute(
        path: AppRoutePaths.home,
        builder: (context, state) => const DashboardScreen(),
        routes: [
          // Add nested routes here if needed
        ],
      ),
    ],
    // errorBuilder: (context, state) => ErrorScreen(error: state.error), // TODO: Implement ErrorScreen
    redirect: (BuildContext context, GoRouterState state) async { // Made redirect async
      final prefs = ref.read(sharedPreferencesProvider); // Read SharedPreferences
      final bool isBoardingComplete = await OnboardingBloc.isOnboardingComplete(prefs);
      final bool onOnboardingScreen = state.matchedLocation == AppRoutePaths.onboarding;

      // If onboarding is not complete, redirect to onboarding screen
      if (!isBoardingComplete) {
        return onOnboardingScreen ? null : AppRoutePaths.onboarding;
      }

      // If onboarding is complete, proceed with auth checks
      final authState = ref.watch(authNotifierProvider);
      final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup' || state.matchedLocation == '/verify-otp';
      final splashing = state.matchedLocation == AppRoutePaths.splash;

      if (authState is AuthInitial || authState is AuthLoading) {
        return splashing ? null : AppRoutePaths.splash; // Stay on splash or go to splash if not already there
      }

      if (authState is Unauthenticated) {
        // If unauthenticated and not on splash, auth pages, or onboarding (which is now handled),
        // redirect to login.
        return (loggingIn || splashing || onOnboardingScreen) ? null : AppRoutePaths.login;
      }

      if (authState is Authenticated) {
        // If authenticated and on splash, login, signup, otp, or onboarding, redirect to home
        if (splashing || loggingIn || onOnboardingScreen) return AppRoutePaths.home;
      }
      
      // For AuthFailureState, decide if you want to redirect or show error on current page
      // if (authState is AuthFailureState) {
      //   return '/error'; // Or handle inline
      // }

      return null; // No redirect needed
    },
  );
});
