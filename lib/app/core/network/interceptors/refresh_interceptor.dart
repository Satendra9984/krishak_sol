import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/app/core/services/token_storage_service_impl.dart';
import 'package:bhoomi_sakti/common/auth/entities/tokens_entity.dart';
import 'package:dio/dio.dart';

class RefreshInterceptor extends Interceptor {
  final TokenStorageService _tokenStorage;
  final Dio _dio;
  bool _isRefreshing = false;
  final List<RequestOptions> _queue = [];

  RefreshInterceptor(this._tokenStorage, this._dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final isAuthEndpoint = err.requestOptions.path.endsWith('/auth/refresh');

    if (status == 401 && !isAuthEndpoint) {
      // Queue this failed request
      _queue.add(err.requestOptions);

      if (!_isRefreshing) {
        _isRefreshing = true;
        try {
          final refreshToken = _tokenStorage.refreshToken;
          if (refreshToken == null || refreshToken.isEmpty) {
            throw InvalidRefreshTokenException();
          }

          // Lock outgoing requests
          // _dio.interceptors.lo.lock();
          // _dio.interceptors.responseLock.lock();

          // Call refresh endpoint directly without interceptors
          final opts = Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          );
          final resp = await _dio.post(
            '/auth/refresh',
            data: {'refreshToken': refreshToken},
            options: opts,
          );

          final newTokens = TokensEntity.fromJson(resp.data);
          await _tokenStorage.storeTokens(newTokens);

          // Retry all queued requests with new token
          for (var requestOptions in _queue) {
            requestOptions.headers['Authorization'] =
                'Bearer ${newTokens.accessToken}';
            _dio.fetch(requestOptions);
          }
        } catch (e) {
          // Refresh failed: clear tokens and propagate
          await _tokenStorage.clearTokens();
          handler.next(
            DioException(
              requestOptions: err.requestOptions,
              error: e,
              response: err.response,
              type: err.type,
            ),
          );
        } finally {
          _isRefreshing = false;
          _queue.clear();
          // Unlock
          // _dio.interceptors.requestLock.unlock();
          // _dio.interceptors.responseLock.unlock();
        }
      }
      return; // queued or handling
    }
    handler.next(err);
  }
}
