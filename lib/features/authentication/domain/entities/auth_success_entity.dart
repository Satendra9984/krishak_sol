import 'package:bhoomi_sakti/common/auth/entities/tokens_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:bhoomi_sakti/common/auth/entities/user_entity.dart';

class AuthSuccessEntity extends Equatable {
  final UserEntity user;
  final TokensEntity tokens;

  const AuthSuccessEntity({required this.user, required this.tokens});

  @override
  List<Object?> get props => [user, tokens];
}
