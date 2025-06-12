import 'package:bhoomi_sakti/app/config/flavors/flavor_config.dart';
import 'package:bhoomi_sakti/app/core/network/interceptors/error_interceptor.dart';
import 'package:bhoomi_sakti/app/core/network/interceptors/refresh_interceptor.dart';
import 'package:bhoomi_sakti/app/core/network/interceptors/token_interceptor.dart';
import 'package:bhoomi_sakti/app/core/services/token_storage_service_impl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bhoomi_sakti/app/core/network/api_client.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// TODO: Replace with actual base URL from configuration
const String _appBaseUrl = 'YOUR_BASE_URL_HERE/api';

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

// final isarInstanceProvider = Provider<Isar>((ref) {
//   // This will throw if not overridden, which is intentional to ensure it's provided.
//   throw UnimplementedError(
//     'Isar instance provider must be overridden in ProviderScope',
//   );
// });

final flavorConfigProvider = Provider<FlavorConfig>(
  (ref) => FlavorConfig.instance,
);

// Provider for FlutterSecureStorage
final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

// Provider for TokenStorageService
final tokenStorageServiceProvider = Provider<TokenStorageService>((ref) {
  return TokenStorageServiceImpl(ref.watch(flutterSecureStorageProvider));
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: _appBaseUrl));

  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  dio.options.headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Attach interceptors
  dio.interceptors.addAll([
    TokenInterceptor(
      tokenStorageService: ref.read(tokenStorageServiceProvider),
    ),
    RefreshInterceptor(ref.read(tokenStorageServiceProvider), dio),
    ErrorInterceptor(),
    PrettyDioLogger(requestHeader: true, responseBody: true),
  ]);

  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: _appBaseUrl, dio: ref.read(dioProvider));
});
