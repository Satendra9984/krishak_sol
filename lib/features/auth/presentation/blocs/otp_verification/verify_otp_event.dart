import 'package:equatable/equatable.dart';

abstract class VerifyOtpEvent extends Equatable {
  const VerifyOtpEvent();

  @override
  List<Object> get props => [];
}

class VerifyOtpButtonPressed extends VerifyOtpEvent {
  final String mobileNumber;
  final String otp;

  const VerifyOtpButtonPressed({
    required this.mobileNumber,
    required this.otp,
  });

  @override
  List<Object> get props => [mobileNumber, otp];
}
