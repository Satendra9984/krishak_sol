import 'package:bhoomi_sakti/app/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/common/models/user_model.dart';

abstract class UserProfileRemoteDatasource {
  Future<UserModel> getCurrentUser();
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDatasource {
  final ApiClient apiClient;

  UserProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.get('/user/me');
      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(message: 'Failed to get current user');
      }
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      throw ServerException(
        message: e.message ?? 'Network error fetching user',
        data: e.response?.data,
      );
    }
  }
}
