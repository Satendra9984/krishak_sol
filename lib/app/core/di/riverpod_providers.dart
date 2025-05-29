import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:bhoomi_sakti/app/config/flavors/flavor_config.dart';
// Import other necessary files for providers

// --- Flavor Config --- //
final flavorConfigProvider = Provider<FlavorConfig>((ref) => FlavorConfig.instance);

// --- Network Providers --- //
final dioProvider = Provider<Dio>((ref) {
  final flavorConfig = ref.watch(flavorConfigProvider);
  final options = BaseOptions(
    baseUrl: flavorConfig.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    // TODO: Add headers, interceptors etc.
    // headers: {
    //   'Content-Type': 'application/json',
    //   'Accept': 'application/json',
    // },
  );
  final dio = Dio(options);

  // Optional: Add interceptors (e.g., for logging, auth tokens)
  // dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  // dio.interceptors.add(AuthInterceptor(ref)); // Example auth interceptor
  return dio;
});

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

// --- Local Storage (Isar) --- //
// The Isar instance is initialized in main_common.dart
// This provider is a placeholder and should be overridden in ProviderScope in main_common.dart
final isarInstanceProvider = Provider<Isar>((ref) {
  // This will throw if not overridden, which is intentional to ensure it's provided.
  throw UnimplementedError('Isar instance provider must be overridden in ProviderScope');
});

// --- Other Core Providers --- //
// Example: SharedPreferences (if you decide to use it for simple key-value storage)
// final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
//   return await SharedPreferences.getInstance();
// });

// TODO: Add providers for your repositories, usecases, and BLoCs/Notifiers as needed.
// Example Repository Provider:
// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   final dio = ref.watch(dioProvider);
//   final isar = ref.watch(isarInstanceProvider);
//   return AuthRepositoryImpl(dio, isar, ref.watch(connectivityProvider));
// });

// Example Usecase Provider:
// final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
//   return LoginUsecase(ref.watch(authRepositoryProvider));
// });

// Example BLoC/Notifier Provider:
// final authBlocProvider = StateNotifierProvider<AuthBloc, AuthState>((ref) {
//   return AuthBloc(ref.watch(loginUsecaseProvider));
// });
