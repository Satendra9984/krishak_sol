import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/features/authentication/auth_providers.dart'
    as auth_providers;
import 'package:bhoomi_sakti/features/authentication/presentation/pages/login_page.dart';
import 'package:bhoomi_sakti/features/authentication/presentation/pages/signup_page.dart';
import 'package:bhoomi_sakti/features/authentication/presentation/pages/otp_verification_page.dart';

import 'package:bhoomi_sakti/app/router/app_route_paths.dart';

/// Returns a list of GoRoute for authentication flows.
List<GoRoute> getAuthRoutes(Ref ref) => [
  GoRoute(
    path: AppRoutePaths.login,
    name: AppRoutePaths.login,
    builder:
        (context, state) => BlocProvider.value(
          value: ref.read(auth_providers.loginBlocProvider),
          child: const LoginPage(),
        ),
  ),
  GoRoute(
    path: AppRoutePaths.signUp,
    name: AppRoutePaths.signUp,
    builder:
        (context, state) => BlocProvider.value(
          value: ref.read(auth_providers.signupBlocProvider),
          child: const SignupPage(),
        ),
  ),
  GoRoute(
    path: AppRoutePaths.otpVerification, // Use constant for path
    name: AppRoutePaths.otpVerification,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      final mobileNumber = extra?['mobileNumber'] as String?;
      final flowType = extra?['flowType'] as OtpFlowType?;

      if (mobileNumber == null || flowType == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Error: OTP verification details missing. Redirecting.',
              ),
            ),
          );
          context.go(AppRoutePaths.login);
        });
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ); // Placeholder while redirecting
      }
      return OtpVerificationPage(
        mobileNumber: mobileNumber,
        flowType: flowType,
      );
    },
  ),
];
