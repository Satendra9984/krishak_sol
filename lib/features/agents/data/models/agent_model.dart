import 'package:bhoomi_sakti/features/agents/domain/agent_entity.dart';

class AgentModel extends Agent {
  const AgentModel({
    required int userId,
    required String name,
    required String mobileNumber,
    String? otp,
    DateTime? otpExpiry,
    required String location,
    required AgentRole role,
    String? profilePictureUrl,
    required bool active,
  }) : super(
         userId: userId,
         name: name,
         mobileNumber: mobileNumber,
         otp: otp,
         otpExpiry: otpExpiry,
         location: location,
         role: role,
         profilePictureUrl: profilePictureUrl,
         active: active,
       );

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      userId: json['userId'] as int,
      name: json['name'] as String,
      mobileNumber: json['mobileNumber'] as String,
      otp: json['otp'] as String?,
      otpExpiry:
          json['otpExpiry'] != null
              ? DateTime.parse(json['otpExpiry'] as String)
              : null,
      location: json['location'] as String,
      role: AgentRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => AgentRole.AGENT,
      ),
      profilePictureUrl: json['profilePictureUrl'] as String?,
      active: json['active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'mobileNumber': mobileNumber,
      'otp': otp,
      'otpExpiry': otpExpiry?.toIso8601String(),
      'location': location,
      'role': role.name,
      'profilePictureUrl': profilePictureUrl,
      'active': active,
    };
  }

  factory AgentModel.fromEntity(Agent agent) {
    return AgentModel(
      userId: agent.userId,
      name: agent.name,
      mobileNumber: agent.mobileNumber,
      otp: agent.otp,
      otpExpiry: agent.otpExpiry,
      location: agent.location,
      role: agent.role,
      profilePictureUrl: agent.profilePictureUrl,
      active: agent.active,
    );
  }
}
