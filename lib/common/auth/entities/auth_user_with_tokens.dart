import 'package:bhoomi_sakti/common/auth/entities/tokens_entity.dart';

import '../../../../common/auth/entities/user_entity.dart';

class AuthUserWithTokens {
  final UserEntity user;
  final TokensEntity tokens;

  AuthUserWithTokens({required this.user, required this.tokens});
}
