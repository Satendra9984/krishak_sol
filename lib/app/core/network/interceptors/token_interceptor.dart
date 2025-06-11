import 'package:bhoomi_sakti/app/core/services/token_storage_service_impl.dart';
import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  final TokenStorageService tokenStorageService;
  // Define paths that should not have the token attached
  final List<String> _excludedPaths = [
    '/auth/login',
    '/auth/signup',
    '/auth/verify-otp',
    '/auth/refresh',
  ];

  TokenInterceptor({required this.tokenStorageService});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check if the request path is in the excluded list
    bool isExcluded = _excludedPaths.any((path) => options.path.endsWith(path));

    if (!isExcluded) {
      final accessToken = tokenStorageService.accessToken;
      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    return handler.next(options);
  }
}
