import 'package:bhoomi_sakti/common/auth/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.userId,
    required super.name,
    required super.mobileNumber,
    required super.role,
    super.profilePictureUrl,
    required super.active,
    super.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as int,
      name: json['name'] as String,
      mobileNumber: json['mobileNumber'] as String,
      role: json['role'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      active: json['active'] as bool,
      location: json['location'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'mobileNumber': mobileNumber,
      'role': role,
      'profilePictureUrl': profilePictureUrl,
      'active': active,
      'location': location,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      name: name,
      mobileNumber: mobileNumber,
      role: role,
      profilePictureUrl: profilePictureUrl,
      active: active,
      location: location,
    );
  }
}
