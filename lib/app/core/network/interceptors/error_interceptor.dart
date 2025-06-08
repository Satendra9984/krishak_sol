import 'package:dio/dio.dart';
import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Default to a generic server exception
    AppException appException = ServerException(message: err.message ?? 'Unknown network error');

    if (err.response != null) {
      final statusCode = err.response!.statusCode;
      final responseData = err.response!.data;

      // You can customize this based on your API's error response structure
      String apiErrorMessage = responseData is Map && responseData.containsKey('message')
          ? responseData['message']
          : err.message ?? 'API Error';

      switch (statusCode) {
        case 400:
          // Check for specific error codes if your API provides them
          if (responseData is Map && responseData.containsKey('errorCode')) {
            final errorCode = responseData['errorCode'];
            if (errorCode == 'USER_ALREADY_EXISTS') {
              appException = UserAlreadyExistsException(message: apiErrorMessage);
            } else if (errorCode == 'INVALID_OTP') {
              appException = InvalidOtpException(message: apiErrorMessage);
            } else {
              appException = BadRequestException(apiErrorMessage, data: responseData);
            }
          } else {
            appException = BadRequestException(apiErrorMessage, data: responseData);
          }
          break;
        case 401:
          if (responseData is Map && responseData.containsKey('errorCode')) {
            final errorCode = responseData['errorCode'];
            if (errorCode == 'INVALID_REFRESH_TOKEN') {
              appException = InvalidRefreshTokenException(message: apiErrorMessage);
            } else {
               appException = UnauthorizedException(message: apiErrorMessage, data: responseData);
            }
          } else {
             appException = UnauthorizedException(message: apiErrorMessage, data: responseData);
          }
          break;
        case 403:
          appException = UnauthorizedException(message: 'Forbidden: $apiErrorMessage', data: responseData);
          break;
        case 404:
           if (responseData is Map && responseData.containsKey('errorCode')) {
            final errorCode = responseData['errorCode'];
            if (errorCode == 'USER_NOT_FOUND') {
              appException = UserNotFoundException(message: apiErrorMessage);
            } else {
              appException = NotFoundException(message: apiErrorMessage, data: responseData);
            }
          } else {
            appException = NotFoundException(message: apiErrorMessage, data: responseData);
          }
          break;
        case 500:
        case 502:
        case 503:
          appException = ServerException(message: 'Server error: $apiErrorMessage', data: responseData);
          break;
        default:
          appException = ServerException(message: 'Unhandled API error ($statusCode): $apiErrorMessage', data: responseData);
      }
    } else if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      appException = TimeoutException('Request timed out: ${err.message}');
    } else if (err.type == DioExceptionType.cancel) {
      appException = RequestCancelledException('Request cancelled: ${err.message}');
    } else if (err.type == DioExceptionType.connectionError) {
       appException = NoInternetException(); // Or a more generic connection error
    }
    // Instead of creating a new DioException, we'll pass our custom AppException
    // The repository layer will catch this AppException and convert it to a Failure.
    // To make this work seamlessly, the AuthRemoteDataSourceImpl should rethrow AppExceptions.
    // For now, we'll let it propagate as a DioException but enriched.
    // A better approach is to have the remote data source catch DioException and throw AppException.
    // For this iteration, we pass a DioException with the AppException in its error field.
    return handler.next(DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: appException, // Embed our custom exception here
        message: appException.message
    ));
  }
}
