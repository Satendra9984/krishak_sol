import 'version_remote_data_source.dart';

import 'package:bhoomi_sakti/features/auth/domain/entities/auth_user_with_tokens.dart';
import 'package:bhoomi_sakti/features/auth/domain/entities/user_entity.dart';
import 'package:bhoomi_sakti/features/auth/domain/entities/tokens_entity.dart';

class VersionRemoteDataSourceImpl implements VersionRemoteDataSource {
  @override
  Future<String> getLatestVersion() async {
    // TODO: Replace with real API call
    return '2.0.0';
  }

  @override
  Future<AuthUserWithTokens?> checkAuthAndGetUser() async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 300));
    // Simulate: return AuthUserWithTokens if authenticated, or null if not
    // Replace with real backend logic
    return AuthUserWithTokens(
      user: UserEntity(
        userId: 1,
        name: 'Demo User',
        mobileNumber: '9999999999',
        role: 'farmer',
        profilePictureUrl: null,
        active: true,
      ),
      tokens: TokensEntity(
        accessToken: 'dummy_access',
        refreshToken: 'dummy_refresh',
        accessExpiry: DateTime.now().add(const Duration(hours: 1)),
        refreshExpiry: DateTime.now().add(const Duration(days: 30)),
      ),
    );
    // return null; // Uncomment to simulate unauthenticated
  }
}
