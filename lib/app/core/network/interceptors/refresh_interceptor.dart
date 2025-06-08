import 'package:dio/dio.dart';
import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/app/core/services/token_storage_service.dart';
import 'package:bhoomi_sakti/features/auth/domain/repositories/auth_repository.dart';

class RefreshInterceptor extends Interceptor {
  final TokenStorageService tokenStorageService;
  final AuthRepository authRepository; // Or RefreshTokenUsecase
  final Dio dio; // Used to retry the request

  // TODO: Implement a proper locking mechanism to prevent multiple concurrent refresh calls
  bool _isRefreshing = false;
  List<Function(String)> _requestQueue = [];

  RefreshInterceptor({
    required this.tokenStorageService,
    required this.authRepository,
    required this.dio,
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && err.error is UnauthorizedException) {
      // Avoid refresh loops if the refresh token itself is invalid
      if (err.error is InvalidRefreshTokenException || err.requestOptions.path.endsWith('/auth/refresh')) {
        await tokenStorageService.clearTokens();
        // Optionally, notify AuthNotifier to update state to unauthenticated
        return handler.next(err); 
      }

      if (_isRefreshing) {
        // If already refreshing, queue the request
        _requestQueue.add((newAccessToken) async {
          err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          try {
            handler.resolve(await dio.fetch(err.requestOptions));
          } catch (e) {
            handler.reject(err); // Or a new DioException if retry fails
          }
        });
        return; // Don't proceed further until token is refreshed
      }

      _isRefreshing = true;

      try {
        final currentRefreshToken = await tokenStorageService.getRefreshToken();
        if (currentRefreshToken == null) {
          _isRefreshing = false;
          _clearQueue(null);
          await tokenStorageService.clearTokens();
          return handler.next(err); // No refresh token, propagate error
        }

        final result = await authRepository.refreshToken(currentRefreshToken);

        await result.fold(
          (failure) async {
            _isRefreshing = false;
            _clearQueue(null);
            await tokenStorageService.clearTokens();
            // Propagate the original error or a new one indicating refresh failure
            // Consider creating a specific SessionExpiredFailure/Exception
            return handler.next(DioException(
              requestOptions: err.requestOptions,
              error: InvalidRefreshTokenException(message: failure.message),
              response: err.response, // Pass original response
              type: err.type // Preserve original type
            ));
          },
          (newTokens) async {
            await tokenStorageService.saveTokens(newTokens);
            _isRefreshing = false;
            _clearQueue(newTokens.accessToken);
            
            // Retry the original request with the new token
            err.requestOptions.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';
            try {
                return handler.resolve(await dio.fetch(err.requestOptions));
            } catch (e) {
                return handler.reject(DioException(
                    requestOptions: err.requestOptions, 
                    error: e, 
                    response: err.response
                ));
            }
          },
        );
      } catch (e) {
        _isRefreshing = false;
        _clearQueue(null);
        await tokenStorageService.clearTokens();
        return handler.next(DioException(
            requestOptions: err.requestOptions, 
            error: e, 
            response: err.response
        ));
      }
    } else {
      return handler.next(err);
    }
  }

  void _clearQueue(String? newAccessToken) {
    for (var callback in _requestQueue) {
      if (newAccessToken != null) {
        callback(newAccessToken);
      } else {
        // If refresh failed, we might need to reject these queued requests
        // For now, this logic assumes they will fail similarly or be handled by their own error paths
      }
    }
    _requestQueue.clear();
  }
}
