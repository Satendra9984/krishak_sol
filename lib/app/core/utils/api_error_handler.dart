import 'package:dio/dio.dart';
import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';

/// A utility class for handling API errors and converting them to appropriate failures
class ApiErrorHandler {
  /// Converts a DioError to an appropriate Failure
  static Failure handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return NetworkFailure.timeout('Request timed out');
    } else if (error.type == DioExceptionType.connectionError) {
      return const NetworkFailure('No internet connection');
    } else if (error.response != null) {
      // Handle HTTP error responses
      return _handleResponseError(error.response!, error.requestOptions);
    } else {
      // Handle other Dio errors
      return ExceptionFailure.from(
        UnexpectedException(
          message: error.message ?? 'An unknown error occurred',
        ),
      );
    }
  }

  /// Handles HTTP response errors
  static Failure _handleResponseError(
    Response response,
    RequestOptions requestOptions,
  ) {
    final statusCode = response.statusCode ?? 500;
    final responseData = response.data;

    switch (statusCode) {
      case 400:
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('errors')) {
          return ValidationFailure.fromMap(responseData);
        }
        return ExceptionFailure(
          BadRequestException(
            responseData['message']?.toString() ?? 'Bad Request',
            code: responseData['code']?.toString(),
            data: responseData,
          ),
        );
      case 401:
        return AuthFailure.unauthorized(
          message: responseData['message']?.toString(),
        );
      case 403:
        return const AuthFailure(
          'You do not have permission to access this resource',
          code: 'FORBIDDEN',
        );
      case 404:
        return ExceptionFailure(
          NotFoundException(
            message:
                responseData['message']?.toString() ?? 'Resource not found',
            code: responseData['code']?.toString(),
          ),
        );
      case 408:
        return NetworkFailure.timeout('Request timed out');
      case 429:
        return const NetworkFailure(
          'Too many requests. Please try again later.',
          code: 'TOO_MANY_REQUESTS',
        );
      case 500:
      case 502:
      case 503:
        return NetworkFailure.serverError(
          message:
              responseData['message']?.toString() ??
              'Server error occurred. Please try again later.',
          code: responseData['code']?.toString() ?? 'SERVER_ERROR',
          data: responseData,
        );
      default:
        return ExceptionFailure(
          ServerException(
            message: responseData['message']?.toString() ?? 'An error occurred',
            code: responseData['code']?.toString() ?? 'UNKNOWN_ERROR',
            data: responseData,
          ),
        );
    }
  }

  /// Handles generic errors and exceptions
  static Failure handleError(dynamic error) {
    if (error is DioException) {
      return handleDioError(error);
    } else if (error is AppException) {
      return ExceptionFailure(error);
    } else if (error is Failure) {
      return error;
    } else {
      return ExceptionFailure(
        UnexpectedException(
          message: error?.toString() ?? 'An unknown error occurred',
        ),
      );
    }
  }
}
