import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/app/router/app_router.dart' show goRouterProvider;
import 'package:bhoomi_sakti/app/config/theme/app_theme.dart' show appThemeProvider;
import 'package:bhoomi_sakti/app/config/flavors/flavor_config.dart';
import 'package:bhoomi_sakti/features/onboarding/onboarding_providers.dart';

class BhoomiSaktiApp extends ConsumerWidget {
  const BhoomiSaktiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize onboarding providers
    ref.watch(onboardingBlocProvider);
    
    final goRouter = ref.watch(goRouterProvider);
    final appTheme = ref.watch(appThemeProvider);

    return MaterialApp.router(
      title: FlavorConfig.instance.appName,
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme, // Optional: if you have a dark theme
      themeMode: ThemeMode.light, // Or ThemeMode.system, ThemeMode.dark
      routerConfig: goRouter,
      debugShowCheckedModeBanner: FlavorConfig.instance.isDevelopment,
    );
  }
}
