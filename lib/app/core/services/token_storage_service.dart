import 'package:bhoomi_sakti/features/auth/domain/entities/tokens_entity.dart';

abstract class TokenStorageService {
  Future<void> saveTokens(TokensEntity tokens);
  Future<TokensEntity?> getTokens();
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
}
