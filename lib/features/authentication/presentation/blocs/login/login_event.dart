import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String mobileNumber;
  // final String password; // Password field removed for OTP flow

  const LoginButtonPressed({
    required this.mobileNumber,
    // required this.password,
  });

  @override
  List<Object> get props => [mobileNumber];
}

class ResendLoginOtp extends LoginEvent {
  final String mobileNumber;

  const ResendLoginOtp({required this.mobileNumber});

  @override
  List<Object> get props => [mobileNumber];
}
