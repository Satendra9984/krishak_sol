import 'package:equatable/equatable.dart';

enum AgentRole { AGENT }

class Agent extends Equatable {
  final int userId;
  final String name;
  final String mobileNumber;
  final String? otp;
  final DateTime? otpExpiry;
  final String location;
  final AgentRole role;
  final String? profilePictureUrl;
  final bool active;

  const Agent({
    required this.userId,
    required this.name,
    required this.mobileNumber,
    this.otp,
    this.otpExpiry,
    required this.location,
    required this.role,
    this.profilePictureUrl,
    required this.active,
  });

  @override
  List<Object?> get props => [
    userId,
    name,
    mobileNumber,
    otp,
    otpExpiry,
    location,
    role,
    profilePictureUrl,
    active,
  ];
}
