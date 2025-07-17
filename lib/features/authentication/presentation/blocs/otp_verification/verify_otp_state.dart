import 'package:equatable/equatable.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/features/authentication/domain/entities/auth_success_entity.dart';

abstract class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object?> get props => [];
}

class VerifyOtpInitial extends VerifyOtpState {
  const VerifyOtpInitial();
}

class VerifyOtpLoading extends VerifyOtpState {
  const VerifyOtpLoading();
}

class VerifyOtpSuccess extends VerifyOtpState {
  final AuthSuccessEntity authSuccessEntity;

  const VerifyOtpSuccess({required this.authSuccessEntity});

  @override
  List<Object?> get props => [authSuccessEntity];
}

class VerifyOtpFailure extends VerifyOtpState {
  final Failure failure;

  const VerifyOtpFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class VerifyOtpResendLoading extends VerifyOtpState {
  const VerifyOtpResendLoading();
}

class VerifyOtpResendSuccess extends VerifyOtpState {
  const VerifyOtpResendSuccess();
}

class VerifyOtpResendFailure extends VerifyOtpState {
  final Failure failure;

  const VerifyOtpResendFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
