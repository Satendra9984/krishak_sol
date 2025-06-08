import 'user_entity.dart';
import 'tokens_entity.dart';

class AuthUserWithTokens {
  final UserEntity user;
  final TokensEntity tokens;

  AuthUserWithTokens({required this.user, required this.tokens});
}
