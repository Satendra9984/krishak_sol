import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupButtonPressed extends SignupEvent {
  final String name;
  final String mobileNumber;

  const SignupButtonPressed({
    required this.name,
    required this.mobileNumber,
  });

  @override
  List<Object> get props => [name, mobileNumber];
}

class ResendSignupOtp extends SignupEvent {
  final String mobileNumber;
  // Not including name for now, assuming backend can handle resend with mobile only
  // or that the initial signup request already created a pending user record.

  const ResendSignupOtp({required this.mobileNumber});

  @override
  List<Object> get props => [mobileNumber];
}
