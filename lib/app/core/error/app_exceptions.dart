/// Base class for all application exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic data;

  const AppException(this.message, {this.code, this.data});

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Exception thrown when there's no internet connection
class NoInternetException extends AppException {
  const NoInternetException() : super('No internet connection available');
}

/// Exception thrown when a request times out
class TimeoutException extends AppException {
  const TimeoutException(String message) : super(message);
}

/// Exception for bad request errors (400)
class BadRequestException extends AppException {
  const BadRequestException(
    String message, {
    String? code,
    dynamic data,
  }) : super(message, code: code, data: data);
}

/// Exception for server communication errors
class ServerException extends AppException {
  const ServerException({
    String message = 'Server error occurred',
    String? code,
    dynamic data,
  }) : super(message, code: code, data: data);
}

/// Exception for unauthorized access
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    String message = 'Unauthorized access',
    String? code,
    dynamic data,
  }) : super(message, code: code, data: data);
}

/// Exception for not found errors
class NotFoundException extends AppException {
  const NotFoundException({
    String message = 'Requested resource not found',
    String? code,
    dynamic data,
  }) : super(message, code: code, data: data);
}

/// Exception for validation errors
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  const ValidationException({
    String message = 'Validation failed',
    String? code,
    this.errors,
  }) : super(message, code: code, data: errors);
}

/// Exception for cache related errors
class CacheException extends AppException {
  const CacheException({String message = 'Cache error occurred', String? code})
    : super(message, code: code);
}

/// Exception for platform specific errors
class PlatformException extends AppException {
  const PlatformException({
    String message = 'Platform specific error occurred',
    String? code,
    dynamic data,
  }) : super(message, code: code, data: data);
}

/// Exception for feature not available in current app version
class FeatureNotAvailableException extends AppException {
  const FeatureNotAvailableException({
    String message =
        'This feature is not available in your current app version',
    String? code = 'FEATURE_NOT_AVAILABLE',
  }) : super(message, code: code);
}

/// Exception when a user already exists during signup
class UserAlreadyExistsException extends AppException {
  const UserAlreadyExistsException({
    String message = 'User with this mobile number already exists',
    String? code = 'USER_ALREADY_EXISTS',
  }) : super(message, code: code);
}

/// Exception when a user is not found during login or other operations
class UserNotFoundException extends AppException {
  const UserNotFoundException({
    String message = 'User with this mobile number not found',
    String? code = 'USER_NOT_FOUND',
  }) : super(message, code: code);
}

/// Exception for an invalid OTP
class InvalidOtpException extends AppException {
  const InvalidOtpException({
    String message = 'The OTP provided is invalid or has expired',
    String? code = 'INVALID_OTP',
  }) : super(message, code: code);
}

/// Exception for an invalid refresh token
class InvalidRefreshTokenException extends AppException {
  const InvalidRefreshTokenException({
    String message = 'The refresh token is invalid or has expired',
    String? code = 'INVALID_REFRESH_TOKEN',
  }) : super(message, code: code);
}

/// Exception for parsing errors
class ParsingException extends AppException {
  const ParsingException({
    String message = 'Error parsing data',
    String? code,
    dynamic data,
  }) : super(message, code: code, data: data);
}

/// Exception for unexpected errors
class UnexpectedException extends AppException {
  const UnexpectedException({
    String message = 'An unexpected error occurred',
    String? code,
    dynamic data,
  }) : super(message, code: code, data: data);
}

/// Exception for when a request is cancelled
class RequestCancelledException extends AppException {
  const RequestCancelledException(String message) : super(message, code: 'REQUEST_CANCELLED');
}

/// Extension to convert exceptions to user-friendly messages
extension AppExceptionExtension on AppException {
  String get userFriendlyMessage {
    if (this is NoInternetException) {
      return 'No internet connection. Please check your connection and try again.';
    } else if (this is TimeoutException) {
      return 'Request timed out. Please try again.';
    } else if (this is ServerException) {
      return 'Server error occurred. Please try again later.';
    } else if (this is UnauthorizedException) {
      return 'Session expired. Please log in again.';
    } else if (this is NotFoundException) {
      return 'Requested resource not found.';
    } else if (this is ValidationException) {
      return message;
    } else if (this is CacheException) {
      return 'Failed to load data. Please try again.';
    } else if (this is PlatformException) {
      return 'A platform error occurred. Please try again.';
    } else if (this is FeatureNotAvailableException) {
      return 'This feature is not available in your current app version.';
    } else if (this is ParsingException) {
      return 'Error processing data. Please try again.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
