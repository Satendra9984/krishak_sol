import 'package:equatable/equatable.dart';

class LoginRequestModel extends Equatable {
  final String mobileNumber;
  final String password;

  const LoginRequestModel({
    required this.mobileNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'mobileNumber': mobileNumber,
      'password': password,
    };
  }

  @override
  List<Object?> get props => [mobileNumber, password];
}
