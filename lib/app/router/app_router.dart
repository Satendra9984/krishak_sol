import 'package:bhoomi_sakti/common/app_common_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/app/core/providers/shared_preferences_provider.dart';
import 'package:bhoomi_sakti/features/splash/splash_providers.dart';
import 'package:bhoomi_sakti/features/splash/presentation/pages/splash.dart';
import 'package:bhoomi_sakti/features/dashboard/presentation/pages/dashboard_screen.dart';

import 'package:bhoomi_sakti/features/authentication/auth_routes.dart';
import 'package:bhoomi_sakti/common/providers/auth_notifier/auth_state.dart';
import 'package:bhoomi_sakti/features/onboarding/onboarding_providers.dart';
import 'package:bhoomi_sakti/features/onboarding/presentation/pages/onboarding_page.dart';

import 'app_route_paths.dart';

// Provider for GoRouter
import 'package:bhoomi_sakti/app/ui/main_scaffold.dart';
import 'package:bhoomi_sakti/features/cart/presentation/pages/cart_page.dart';
import 'package:bhoomi_sakti/features/products/presentation/pages/shop_page.dart';
import 'package:bhoomi_sakti/features/products/presentation/pages/product_details_page.dart';
import 'package:bhoomi_sakti/features/profile/presentation/pages/profile_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
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
        // name: AppRoutePaths.onboarding,
        builder:
            (context, state) => BlocProvider.value(
              value: ref.read(onboardingBlocProvider),
              child: OnboardingPage(),
            ),
      ),

      // Auth Routes
      ...getAuthRoutes(ref),

      // Main App with Bottom Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Dashboard Branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path:
                    AppRoutePaths
                        .dashboard, // This should be the root path for the shell
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Shop Branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutePaths.shop,
                builder: (context, state) => const ShopPage(),
                routes: [
                  GoRoute(
                    path: AppRoutePaths.productDetails,
                    builder: (context, state) {
                      final productId = state.extra as String;
                      return ProductDetailsPage(productId: productId);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Cart Branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutePaths.cart,
                builder: (context, state) => const CartPage(),
              ),
            ],
          ),
          // Profile Branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutePaths.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
    // errorBuilder: (context, state) => ErrorScreen(error: state.error),
    /// TODO: Implement ErrorScreen
    redirect: (BuildContext context, GoRouterState state) async {
      // final onboardingBloc = ref.read(onboardingBlocProvider);
      // final prefs = await ref.read(sharedPreferencesProvider.future);
      // final bool isBoardingComplete = await onboardingBloc.isOnboardingComplete(
      //   prefs,
      // );
      // final bool onOnboardingScreen =
      //     state.matchedLocation == AppRoutePaths.onboarding;

      // // If onboarding is not complete, redirect to onboarding screen
      // if (!isBoardingComplete) {
      //   return onOnboardingScreen ? null : AppRoutePaths.onboarding;
      // }

      // // If onboarding is complete, proceed with auth checks
      // final authState = ref.watch(authNotifierProvider);
      // final loggingIn =
      //     state.matchedLocation == AppRoutePaths.login ||
      //     state.matchedLocation == AppRoutePaths.signUp ||
      //     state.matchedLocation == AppRoutePaths.otpVerification;

      // final splashing = state.matchedLocation == AppRoutePaths.splash;

      // if (authState is AuthInitial || authState is AuthLoading) {
      //   return splashing
      //       ? null
      //       : AppRoutePaths
      //           .splash; // Stay on splash or go to splash if not already there
      // }

      // if (authState is Unauthenticated) {
      //   // If unauthenticated and not on splash, auth pages, or onboarding (which is now handled),
      //   // redirect to login.
      //   return (loggingIn || splashing || onOnboardingScreen)
      //       ? null
      //       : AppRoutePaths.login;
      // }

      // if (authState is Authenticated) {
      //   // If authenticated and on splash, login, signup, otp, or onboarding, redirect to home
      //   if (splashing || loggingIn || onOnboardingScreen) {
      //     return AppRoutePaths.home;
      //   }
      // }

      // // For AuthFailureState, decide if you want to redirect or show error on current page
      // if (authState is AuthFailureState) {
      //   return '/error'; // Or handle inline
      // }

      return null; // No redirect needed
    },
  );
});
