import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int userId;
  final String name;
  final String mobileNumber;
  final String role;
  final String? profilePictureUrl;
  final bool active;

  const UserEntity({
    required this.userId,
    required this.name,
    required this.mobileNumber,
    required this.role,
    this.profilePictureUrl,
    required this.active,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        mobileNumber,
        role,
        profilePictureUrl,
        active,
      ];
}
