import 'package:equatable/equatable.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

// LoginSuccess might not be explicitly needed if AuthNotifier handles global state
// and GoRouter handles redirection. However, it can be useful for showing
// a brief success message or animation on the Login Page itself before redirection.
// For now, we'll assume redirection is handled by AuthNotifier's state change.

class LoginOtpSentSuccess extends LoginState {
  const LoginOtpSentSuccess();
}

class LoginFailure extends LoginState {
  final Failure failure;

  const LoginFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
