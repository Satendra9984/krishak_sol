import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bhoomi_sakti/common/auth/entities/tokens_entity.dart';

/// Token Storage Keys separated for reusability
class TokenStorageKeys {
  static const accessToken = 'accessToken';
  static const refreshToken = 'refreshToken';
}

/// Abstract contract
abstract class TokenStorageService {
  Future<void> initialize();
  Future<void> storeTokens(TokensEntity tokens);
  Future<void> updateAccessToken(String accessToken);
  Future<bool> hasStoredTokens();
  Future<void> reloadFromStorage();
  Future<void> clearTokens();

  String? get accessToken;
  String? get refreshToken;
  bool get hasValidTokens;

  Map<String, dynamic> getTokenInfo();
  void dispose();
}

/// Secure storage-backed implementation
class TokenStorageServiceImpl implements TokenStorageService {
  final FlutterSecureStorage _secureStorage;

  String? _accessToken;
  String? _refreshToken;

  @override
  String? get accessToken => _accessToken;

  @override
  String? get refreshToken => _refreshToken;

  @override
  bool get hasValidTokens => _accessToken != null && _refreshToken != null;

  TokenStorageServiceImpl(this._secureStorage);

  /// Initialize by loading tokens from storage into memory
  @override
  Future<void> initialize() async {
    try {
      await Future.wait([
        Future(() async {
          _accessToken = await _secureStorage.read(
            key: TokenStorageKeys.accessToken,
          );
        }),
        Future(() async {
          _refreshToken = await _secureStorage.read(
            key: TokenStorageKeys.refreshToken,
          );
        }),
      ]);
    } catch (e) {
      _accessToken = null;
      _refreshToken = null;
      throw TokenStorageException('Failed to initialize tokens: $e');
    }
  }

  /// Store both tokens
  @override
  Future<void> storeTokens(TokensEntity tokens) async {
    try {
      _accessToken = tokens.accessToken;
      _refreshToken = tokens.refreshToken;

      await Future.wait([
        _secureStorage.write(
          key: TokenStorageKeys.accessToken,
          value: _accessToken,
        ),
        _secureStorage.write(
          key: TokenStorageKeys.refreshToken,
          value: _refreshToken,
        ),
      ]);
    } catch (e) {
      _accessToken = null;
      _refreshToken = null;
      throw TokenStorageException('Failed to store tokens: $e');
    }
  }

  /// Update access token only (e.g. after refresh)
  @override
  Future<void> updateAccessToken(String accessToken) async {
    try {
      _accessToken = accessToken;
      await _secureStorage.write(
        key: TokenStorageKeys.accessToken,
        value: accessToken,
      );
    } catch (e) {
      throw TokenStorageException('Failed to update access token: $e');
    }
  }

  /// Clear tokens from both memory and storage
  @override
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    try {
      await Future.wait([
        _secureStorage.delete(key: TokenStorageKeys.accessToken),
        _secureStorage.delete(key: TokenStorageKeys.refreshToken),
      ]);
    } catch (e) {
      throw TokenStorageException('Failed to clear tokens: $e');
    }
  }

  /// Check if token exists in storage
  @override
  Future<bool> hasStoredTokens() async {
    try {
      final token = await _secureStorage.read(
        key: TokenStorageKeys.accessToken,
      );
      return token != null;
    } catch (_) {
      return false;
    }
  }

  /// Force reload from storage into memory
  @override
  Future<void> reloadFromStorage() async => await initialize();

  /// Debug info
  @override
  Map<String, dynamic> getTokenInfo() {
    return {
      'hasAccessToken': _accessToken != null,
      'hasRefreshToken': _refreshToken != null,
      'accessTokenLength': _accessToken?.length ?? 0,
      'refreshTokenLength': _refreshToken?.length ?? 0,
    };
  }

  /// Dispose memory references
  @override
  void dispose() {
    _accessToken = null;
    _refreshToken = null;
  }
}
