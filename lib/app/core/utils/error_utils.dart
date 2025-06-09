import 'package:flutter/material.dart';
import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';

/// A utility class for handling and displaying errors in a user-friendly way
class ErrorUtils {
  /// Convert any error to a user-friendly error message
  static String getUserFriendlyMessage(dynamic error) {
    if (error is AppException) {
      return error.userFriendlyMessage;
    } else if (error is Failure) {
      return error.userFriendlyMessage;
    } else if (error is String) {
      return error;
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Show a snackbar with the error message
  static void showErrorSnackBar(
    BuildContext context, {
    required dynamic error,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    final message = getUserFriendlyMessage(error);
    final snackBar = SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
          ],
          Text(message),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      duration: duration,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Handle error by logging and returning a Failure
  static Failure handleError(
    dynamic error, {
    StackTrace? stackTrace,
    String? context,
  }) {
    // Log the error
    debugPrint('Error${context != null ? ' in $context' : ''}: $error');
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }

    // Convert to Failure
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

  /// Handle error and show a snackbar
  static void handleAndShowError(
    BuildContext context, {
    required dynamic error,
    StackTrace? stackTrace,
    String? contextMessage,
    String? snackbarTitle,
  }) {
    final failure = handleError(
      error,
      stackTrace: stackTrace,
      context: contextMessage,
    );
    showErrorSnackBar(context, error: failure, title: snackbarTitle);
  }
}

/// Extension to easily show error dialogs on BuildContext
extension ErrorHandlerExtension on BuildContext {
  /// Show an error snackbar
  void showErrorSnackBar({
    required dynamic error,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    ErrorUtils.showErrorSnackBar(
      this,
      error: error,
      title: title,
      duration: duration,
    );
  }

  /// Handle error and show a snackbar
  void handleError({
    required dynamic error,
    StackTrace? stackTrace,
    String? contextMessage,
    String? snackbarTitle,
  }) {
    ErrorUtils.handleAndShowError(
      this,
      error: error,
      stackTrace: stackTrace,
      contextMessage: contextMessage,
      snackbarTitle: snackbarTitle,
    );
  }
}
