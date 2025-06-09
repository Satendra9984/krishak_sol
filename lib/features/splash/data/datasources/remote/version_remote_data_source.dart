import 'dart:async';

import 'package:bhoomi_sakti/features/auth/domain/entities/auth_user_with_tokens.dart';

abstract class VersionRemoteDataSource {
  Future<String> getLatestVersion();

  /// Returns AuthUserWithTokens if authenticated, null if not
  Future<AuthUserWithTokens?> checkAuthAndGetUser();
}

class VersionRemoteDataSourceImpl implements VersionRemoteDataSource {
  @override
  Future<String> getLatestVersion() async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 300));
    return '2.0.0'; // Simulated latest version
  }

  @override
  Future<AuthUserWithTokens?> checkAuthAndGetUser() {
    // TODO: implement checkAuthAndGetUser
    throw UnimplementedError();
  }
}
