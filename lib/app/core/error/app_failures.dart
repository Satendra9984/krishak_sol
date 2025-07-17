import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';

/// Base class for all failures in the app
abstract class Failure extends Equatable {
  const Failure(this.message, {this.code, this.data});

  final String message;
  final String? code;
  final dynamic data;

  @override
  List<Object?> get props => [message, code, data];

  @override
  bool? get stringify => true;

  @override
  String toString() =>
      'Failure: $message${code != null ? ' (code: $code)' : ''}';
}

/// Failure that wraps an [AppException]
class ExceptionFailure extends Failure {
  final AppException exception;

  ExceptionFailure._({required this.exception})
    : super(exception.message, code: exception.code, data: exception.data);

  @override
  List<Object?> get props => [exception];

  factory ExceptionFailure(AppException exception) =>
      ExceptionFailure._(exception: exception);

  factory ExceptionFailure.from(Exception exception) {
    if (exception is AppException) {
      return ExceptionFailure(exception);
    }
    return ExceptionFailure(UnexpectedException(message: exception.toString()));
  }
}

/// Failure for network related issues
class NetworkFailure extends Failure {
  const NetworkFailure(String message, {String? code, dynamic data})
    : this._(message, code: code, data: data);

  const NetworkFailure._(this.message, {this.code, this.data})
    : super(message, code: code, data: data);

  @override
  final String message;
  @override
  final String? code;
  @override
  final dynamic data;

  factory NetworkFailure.noInternet() =>
      const NetworkFailure('No internet connection', code: 'NO_INTERNET');

  factory NetworkFailure.timeout(String message) =>
      NetworkFailure(message, code: 'TIMEOUT');

  factory NetworkFailure.serverError({
    String message = 'Server error occurred',
    String? code,
    dynamic data,
  }) {
    return NetworkFailure(message, code: code ?? 'SERVER_ERROR', data: data);
  }
}

/// Failure for authentication related issues
class AuthFailure extends Failure {
  const AuthFailure(String message, {String? code, dynamic data})
    : this._(message, code: code, data: data);

  const AuthFailure._(this.message, {this.code, this.data})
    : super(message, code: code, data: data);

  @override
  final String message;
  @override
  final String? code;
  @override
  final dynamic data;

  factory AuthFailure.unauthorized({String? message}) =>
      AuthFailure(message ?? 'Unauthorized access', code: 'UNAUTHORIZED');

  factory AuthFailure.invalidCredentials() => const AuthFailure(
    'Invalid email or password',
    code: 'INVALID_CREDENTIALS',
  );

  factory AuthFailure.sessionExpired() => const AuthFailure(
    'Your session has expired. Please log in again.',
    code: 'SESSION_EXPIRED',
  );
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  final Map<String, List<String>> validationErrors;

  ValidationFailure({
    String message = 'Validation failed',
    String? code,
    required Map<String, dynamic> errors,
  }) : validationErrors = _convertErrors(errors),
       super(message, code: code, data: errors);

  static Map<String, List<String>> _convertErrors(Map<String, dynamic> errors) {
    return errors.map((key, value) {
      if (value is List) {
        return MapEntry(key, value.map((e) => e.toString()).toList());
      } else if (value is String) {
        return MapEntry(key, [value]);
      } else {
        return MapEntry(key, [value.toString()]);
      }
    });
  }

  factory ValidationFailure.fromMap(
    Map<String, dynamic> json, {
    String? message,
    String? code,
  }) {
    return ValidationFailure(
      message: message ?? 'Validation failed',
      code: code ?? 'VALIDATION_ERROR',
      errors: json,
    );
  }

  @override
  List<Object?> get props => [message, code, validationErrors];

  @override
  String toString() =>
      'ValidationFailure: $message (${validationErrors.keys.join(', ')})';
}

/// Failure for server related errors
class ServerFailure extends Failure {
  const ServerFailure({String message = 'Server error occurred', String? code, dynamic data})
      : super(message, code: code ?? 'SERVER_ERROR', data: data);
}

/// Failure for cache related errors
class CacheFailure extends Failure {
  const CacheFailure({String message = 'Cache error occurred', String? code})
    : this._(message, code: code);

  const CacheFailure._(this.message, {this.code}) : super(message, code: code);

  @override
  final String message;
  @override
  final String? code;

  factory CacheFailure.notFound({String? key}) =>
      CacheFailure(code: 'CACHE_NOT_FOUND');
}

/// Failure for feature not available
class FeatureNotAvailableFailure extends Failure {
  const FeatureNotAvailableFailure({
    String message = 'This feature is not available',
    String? code = 'FEATURE_NOT_AVAILABLE',
  }) : this._(message, code: code);

  const FeatureNotAvailableFailure._(this.message, {this.code})
    : super(message, code: code);

  @override
  final String message;
  @override
  final String? code;
}

/// Extension to convert failures to user-friendly messages
extension FailureExtension on Failure {
  String get userFriendlyMessage {
    if (this is NetworkFailure) {
      return 'Network error: $message';
    } else if (this is AuthFailure) {
      return message;
    } else if (this is ValidationFailure) {
      return message;
    } else if (this is CacheFailure) {
      return 'Failed to load data. Please try again.';
    } else if (this is FeatureNotAvailableFailure) {
      return 'This feature is not available in your current app version.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}

/// Extension to handle Either type from fpdart
extension EitherFailure<L extends Object, R> on Either<L, R> {
  /// Get the right value or throw if Left
  R getOrThrow() => getOrElse((l) => throw l);

  /// Get the right value or null if Left
  R? getOrNull() => fold((_) => null, (r) => r);

  /// Handle both cases of Either
  T foldFailure<T>({
    required T Function(Failure failure) onFailure,
    required T Function(R value) onSuccess,
  }) {
    return fold((l) => onFailure(l as Failure), onSuccess);
  }
}

/// Helper to convert exceptions to failures
Failure exceptionToFailure(dynamic error) {
  if (error is Failure) {
    return error;
  } else if (error is AppException) {
    return ExceptionFailure(error);
  } else if (error is Exception) {
    return ExceptionFailure.from(error);
  } else {
    return ExceptionFailure(UnexpectedException());
  }
}
