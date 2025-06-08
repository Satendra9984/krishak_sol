import 'package:equatable/equatable.dart';
import 'package:bhoomi_sakti/features/auth/data/models/user_model.dart';
import 'package:bhoomi_sakti/features/auth/data/models/tokens_model.dart';
import 'package:bhoomi_sakti/features/auth/domain/entities/auth_success_entity.dart';

class AuthSuccessModel extends Equatable {
  final UserModel user;
  final TokensModel tokens;

  const AuthSuccessModel({
    required this.user,
    required this.tokens,
  });

  factory AuthSuccessModel.fromJson(Map<String, dynamic> json) {
    return AuthSuccessModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      tokens: TokensModel.fromJson(json['tokens'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'tokens': tokens.toJson(),
    };
  }

  AuthSuccessEntity toEntity() {
    return AuthSuccessEntity(
      user: user.toEntity(),
      tokens: tokens.toEntity(),
    );
  }

  @override
  List<Object?> get props => [user, tokens];
}
