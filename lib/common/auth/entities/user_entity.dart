import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int userId;
  final String name;
  final String mobileNumber;
  final String role;
  final String? location;
  final String? profilePictureUrl;
  final bool active;

  const UserEntity({
    required this.userId,
    required this.name,
    required this.mobileNumber,
    required this.role,
    this.location,
    this.profilePictureUrl,
    required this.active,
  });

  // Factory constructor to create a UserEntity from a JSON map
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      userId: json['userId'] as int,
      name: json['name'] as String,
      mobileNumber: json['mobileNumber'] as String,
      location: json['location'] as String?,
      role: json['role'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      active: json['active'] as bool,
    );
  }

  /*

{
    "userId": 5,
    "name": "Satendra Pal",
    "mobileNumber": "3333333333",
    "location": null,
    "role": "USER",
    "profilePictureUrl": null,
    "active": false,
}
*/

  // Method to convert a UserEntity to a JSON map
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

  @override
  List<Object?> get props => [
    userId,
    name,
    mobileNumber,
    role,
    location,
    profilePictureUrl,
    active,
  ];
}
