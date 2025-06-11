import 'package:equatable/equatable.dart';

class OtpVerificationEntity extends Equatable {
  final String mobileNumber;
  final String otp;

  const OtpVerificationEntity({
    required this.mobileNumber,
    required this.otp,
  });

  @override
  List<Object?> get props => [mobileNumber, otp];
}
