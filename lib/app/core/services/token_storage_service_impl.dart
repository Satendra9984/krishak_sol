import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bhoomi_sakti/features/auth/domain/entities/tokens_entity.dart';
import 'token_storage_service.dart';

class TokenStorageServiceImpl implements TokenStorageService {
  final FlutterSecureStorage _secureStorage;

  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const _accessExpiryKey = 'accessExpiry';
  static const _refreshExpiryKey = 'refreshExpiry';

  TokenStorageServiceImpl({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  @override
  Future<void> saveTokens(TokensEntity tokens) async {
    await _secureStorage.write(key: _accessTokenKey, value: tokens.accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: tokens.refreshToken);
    if (tokens.accessExpiry != null) {
      await _secureStorage.write(
          key: _accessExpiryKey, value: tokens.accessExpiry!.toIso8601String());
    }
    if (tokens.refreshExpiry != null) {
      await _secureStorage.write(
          key: _refreshExpiryKey, value: tokens.refreshExpiry!.toIso8601String());
    }
  }

  @override
  Future<TokensEntity?> getTokens() async {
    final accessToken = await _secureStorage.read(key: _accessTokenKey);
    final refreshToken = await _secureStorage.read(key: _refreshTokenKey);

    if (accessToken != null && refreshToken != null) {
      final accessExpiryString = await _secureStorage.read(key: _accessExpiryKey);
      final refreshExpiryString = await _secureStorage.read(key: _refreshExpiryKey);
      return TokensEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
        accessExpiry: accessExpiryString != null ? DateTime.tryParse(accessExpiryString) : null,
        refreshExpiry: refreshExpiryString != null ? DateTime.tryParse(refreshExpiryString) : null,
      );
    }
    return null;
  }

  @override
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _accessExpiryKey);
    await _secureStorage.delete(key: _refreshExpiryKey);
  }
}
