import 'package:dio/dio.dart';
import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppException appEx;
    final data = err.response?.data;
    final msg =
        (data is Map && data['message'] != null)
            ? data['message'] as String
            : err.message;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        appEx = TimeoutException('Request timed out: $msg');
        break;
      case DioExceptionType.cancel:
        appEx = RequestCancelledException('Request cancelled');
        break;
      case DioExceptionType.badResponse:
        final code = err.response?.statusCode;
        switch (code) {
          case 400:
            appEx = BadRequestException(msg ?? 'Unknown error', data: data);
            break;
          case 401:
            final errorCode = data is Map ? data['errorCode'] : null;
            if (errorCode == 'INVALID_REFRESH_TOKEN') {
              appEx = InvalidRefreshTokenException(
                message: msg ?? 'Unknown error',
              );
            } else {
              appEx = UnauthorizedException(message: msg ?? 'Unknown error');
            }
            break;
          case 403:
            appEx = UnauthorizedException(
              message: 'Forbidden: ${msg ?? 'Unknown error'}',
            );
            break;
          case 404:
            appEx = NotFoundException(message: msg ?? 'Unknown error');
            break;
          case 500:
          default:
            appEx = ServerException(
              message: 'Server error: ${msg ?? 'Unknown error'}',
            );
            break;
        }
        break;
      case DioExceptionType.badCertificate:
        appEx = const CertificateException('Bad certificate');
        break;
      case DioExceptionType.connectionError:
        appEx = NoInternetException();
        break;
      case DioExceptionType.unknown:
        appEx = UnexpectedException();
        break;
    }

    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: appEx,
        message: appEx.message,
      ),
    );
  }
}
