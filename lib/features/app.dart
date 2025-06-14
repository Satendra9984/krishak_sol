import 'package:bhoomi_sakti/app/config/theme/current_theme_provider.dart';
import 'package:bhoomi_sakti/app/core/providers/core_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/app/router/app_router.dart' show goRouterProvider;

class BhoomiSaktiApp extends ConsumerWidget {
  const BhoomiSaktiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize onboarding providers

    final goRouter = ref.watch(goRouterProvider);
    final appTheme = ref.watch(currentThemeProvider);
    final flavorConfig = ref.watch(flavorConfigProvider);

    return MaterialApp.router(
      title: flavorConfig.appName,
      theme: appTheme,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: flavorConfig.isDevelopment,
    );
  }
}
