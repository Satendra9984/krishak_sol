import 'package:bhoomi_sakti/app/core/providers/core_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/app/router/app_router.dart' show goRouterProvider;
import 'package:bhoomi_sakti/app/config/theme/app_theme.dart'
    show appThemeProvider;

class BhoomiSaktiApp extends ConsumerWidget {
  const BhoomiSaktiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize onboarding providers

    final goRouter = ref.watch(goRouterProvider);
    final appTheme = ref.watch(appThemeProvider);
    final flavorConfig = ref.watch(flavorConfigProvider);

    return MaterialApp.router(
      title: flavorConfig.appName,
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme, // Optional: if you have a dark theme
      themeMode: ThemeMode.light, // Or ThemeMode.system, ThemeMode.dark
      routerConfig: goRouter,
      debugShowCheckedModeBanner: flavorConfig.isDevelopment,
    );
  }
}
