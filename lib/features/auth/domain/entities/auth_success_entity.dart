import 'package:equatable/equatable.dart';
import 'package:bhoomi_sakti/features/auth/domain/entities/user_entity.dart';
import 'package:bhoomi_sakti/features/auth/domain/entities/tokens_entity.dart';

class AuthSuccessEntity extends Equatable {
  final UserEntity user;
  final TokensEntity tokens;

  const AuthSuccessEntity({
    required this.user,
    required this.tokens,
  });

  @override
  List<Object?> get props => [user, tokens];
}
