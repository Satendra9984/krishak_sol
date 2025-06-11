import 'package:bhoomi_sakti/app/core/services/token_storage_service_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/app/config/providers/core_providers.dart';
import 'package:bhoomi_sakti/features/authentication/auth_providers.dart'; // For authRepositoryProvider
import 'package:bhoomi_sakti/app/core/network/interceptors/error_interceptor.dart';
import 'package:bhoomi_sakti/app/core/network/interceptors/token_interceptor.dart';
import 'package:bhoomi_sakti/app/core/network/interceptors/refresh_interceptor.dart';

// TODO: Replace with actual base URL from configuration
const String _appBaseUrl =
    'YOUR_BASE_URL_HERE/api'; // Can be same as auth or different

// Main Application Dio Provider
final appDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: _appBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // Provider for TokenStorageService
  final tokenStorageServiceProvider = Provider<TokenStorageService>((ref) {
    return TokenStorageServiceImpl();
  });

  dio.interceptors.addAll([
    ErrorInterceptor(),
    TokenInterceptor(
      tokenStorageService: ref.watch(tokenStorageServiceProvider),
    ),
    RefreshInterceptor(
      tokenStorageService: tokenStorageService,
      authRepository: tokenStorageService,
      dio: dio, // Pass the dio instance itself for retrying requests
    ),
    // LogInterceptor(requestBody: true, responseBody: true), // Optional: for debugging
  ]);

  return dio;
});
