import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/app/core/services/token_storage_service_impl.dart';
import 'package:bhoomi_sakti/common/auth/entities/tokens_entity.dart';
import 'package:dio/dio.dart';

// The key changes for proper Dio 5.x compatibility:

// Removed locking mechanism: Dio 5.x doesn't have requestLock/responseLock. Instead, we handle concurrency by queuing requests with their handlers.
// Queue both request and handler: The queue now stores both the RequestOptions and the ErrorInterceptorHandler as records, so each request can be properly resolved or rejected.
// Individual request handling: Each queued request is retried individually with proper error handling - if the retry succeeds, we call handler.resolve(), if it fails, we call handler.reject().
// Proper concurrency handling: When _isRefreshing is true, subsequent 401 errors are simply queued and will be processed when the refresh completes.
// Clean error propagation: All queued requests are properly rejected with the appropriate exception when refresh fails.
// No manual locking needed: Dio 5.x handles request management internally, so we don't need to manually lock/unlock interceptors.

// This implementation properly handles the token refresh flow without relying on deprecated locking mechanisms, ensuring all reques

class RefreshInterceptor extends Interceptor {
  final TokenStorageService _tokenStorage;
  final Dio _dio;
  bool _isRefreshing = false;
  final List<({RequestOptions request, ErrorInterceptorHandler handler})>
  _queue = [];

  RefreshInterceptor(this._tokenStorage, this._dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final isAuthEndpoint = err.requestOptions.path.endsWith('/auth/refresh');

    if (status == 401 && !isAuthEndpoint) {
      // Add to queue with both request and handler
      _queue.add((request: err.requestOptions, handler: handler));

      if (!_isRefreshing) {
        _isRefreshing = true;

        try {
          final refreshToken = _tokenStorage.refreshToken;
          if (refreshToken == null || refreshToken.isEmpty) {
            throw InvalidRefreshTokenException();
          }

          // Create a new Dio instance for refresh to avoid interceptor loops
          final refreshDio = Dio();
          refreshDio.options.baseUrl = _dio.options.baseUrl;

          final resp = await refreshDio.post(
            '/auth/refresh',
            data: {'refreshToken': refreshToken},
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          );

          final newTokens = TokensEntity.fromJson(resp.data);
          await _tokenStorage.storeTokens(newTokens);

          // Retry all queued requests with new token
          for (var queuedItem in _queue) {
            try {
              queuedItem.request.headers['Authorization'] =
                  'Bearer ${newTokens.accessToken}';
              final response = await _dio.fetch(queuedItem.request);
              queuedItem.handler.resolve(response);
            } catch (retryError) {
              queuedItem.handler.reject(
                DioException(
                  requestOptions: queuedItem.request,
                  error: retryError,
                  type: DioExceptionType.unknown,
                ),
              );
            }
          }
        } catch (e) {
          // Refresh failed: clear tokens and reject all queued requests
          await _tokenStorage.clearTokens();

          for (var queuedItem in _queue) {
            final refreshException = DioException(
              requestOptions: queuedItem.request,
              error:
                  e is InvalidRefreshTokenException
                      ? e
                      : InvalidRefreshTokenException(),
              response: err.response,
              type: DioExceptionType.unknown,
            );
            queuedItem.handler.reject(refreshException);
          }
        } finally {
          _isRefreshing = false;
          _queue.clear();
        }
      }
      // If already refreshing, the request is queued and will be handled when refresh completes
      return;
    } else {
      // Not a 401 or is auth endpoint, pass through
      handler.next(err);
    }
  }
}
