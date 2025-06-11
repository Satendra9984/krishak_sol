import 'dart:async';

import 'package:bhoomi_sakti/app/core/network/api_client.dart';
import 'package:bhoomi_sakti/common/auth/entities/auth_user_with_tokens.dart';

abstract class SplashRemoteDataSource {
  Future<String> getLatestVersion();

  /// Returns AuthUserWithTokens if authenticated, null if not
  Future<AuthUserWithTokens?> checkAuthAndGetUser();
}

class SplashRemoteDataSourceImpl implements SplashRemoteDataSource {
  final ApiClient apiClient;

  SplashRemoteDataSourceImpl(this.apiClient);

  @override
  Future<String> getLatestVersion() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return '2.0.0'; // Simulated latest version
  }

  @override
  Future<AuthUserWithTokens?> checkAuthAndGetUser() {
    throw UnimplementedError();
  }
}
