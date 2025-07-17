// Placeholder for initial screen - replace with your actual initial screen
import 'package:bhoomi_sakti/app/router/app_route_paths.dart';
import 'package:bhoomi_sakti/common/app_common_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhoomi_sakti/features/splash/presentation/blocs/splash_bloc.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();

    // --- Navigation logic moved to SplashBloc ---
    Future.microtask(() {
      if (!mounted) return;
      final splashBloc = context.read<SplashBloc>();
      splashBloc.add(AppStarted());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorTheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorTheme.surface,
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is NavigateToOnboarding) {
            // debugPrint('[splash]: NavigateToOnboarding');
            context.go(AppRoutePaths.onboarding);
          } else if (state is NavigateToAuth) {
            debugPrint('[splash]: NavigateToAuth');
            context.go(AppRoutePaths.login);
          } else if (state is NavigateToHome) {
            debugPrint('[splash]: NavigateToHome ${state.user}');
            // Set the user profile and tokens globally before navigating to home
            ref
                .read(authNotifierProvider.notifier)
                .setAuthenticatedUser(state.user);
            context.go(AppRoutePaths.dashboard);
          }
        },
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image.asset('assets/images/bhoomi_sakti_logo.png', height: 120),
                const SizedBox(height: 24),
                Text(
                  'Bhoomi Shakti',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: colorTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Empowering Farmers, Agents & Admins',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: colorTheme.primary),
                ),
                const SizedBox(height: 32),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
