import 'package:equatable/equatable.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {
  const SignupInitial();
}

class SignupLoading extends SignupState {
  const SignupLoading();
}

class SignupOtpSentSuccess extends SignupState {
  const SignupOtpSentSuccess();
}

class SignupFailure extends SignupState {
  final Failure failure;

  const SignupFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
