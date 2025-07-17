import 'dart:async';

import 'package:bhoomi_sakti/app/core/network/api_client.dart';
import 'package:bhoomi_sakti/common/auth/entities/user_entity.dart';

abstract class SplashRemoteDataSource {
  Future<String> getLatestVersion();

  /// Returns AuthUserWithTokens if authenticated, null if not
  Future<UserEntity?> checkAuthAndGetUser();
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
  Future<UserEntity?> checkAuthAndGetUser() async {
    try {
      final response = await apiClient.get('/user/me');
      if (response.statusCode == 200) {
        return UserEntity.fromJson(response.data);
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
