import 'package:equatable/equatable.dart';

class OtpRequestEntity extends Equatable {
  final String mobileNumber;
  final String? name; // Optional for login, required for signup

  const OtpRequestEntity({
    required this.mobileNumber,
    this.name,
  });

  @override
  List<Object?> get props => [mobileNumber, name];
}
