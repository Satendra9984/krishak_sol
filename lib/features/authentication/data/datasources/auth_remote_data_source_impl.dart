import 'package:bhoomi_sakti/app/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/common/models/tokens_model.dart';
import 'package:bhoomi_sakti/common/models/user_model.dart';
import 'package:bhoomi_sakti/features/authentication/data/models/otp_request_model.dart';
import 'package:bhoomi_sakti/features/authentication/data/models/otp_verification_model.dart';
import 'package:bhoomi_sakti/common/models/refresh_token_request_model.dart';
import 'package:bhoomi_sakti/features/authentication/data/models/auth_success_model.dart'; // Added import

abstract class AuthRemoteDataSource {
  Future<void> requestSignupOtp(OtpRequestModel signupRequest);
  Future<void> requestLoginOtp(
    OtpRequestModel loginRequest,
  ); // Assuming OtpRequestModel is suitable for login OTP request
  Future<AuthSuccessModel> verifyOtp(OtpVerificationModel otpVerification);
  Future<TokensModel> refreshToken(
    RefreshTokenRequestModel refreshTokenRequest,
  );
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> requestSignupOtp(OtpRequestModel signupRequest) async {
    try {
      final response = await apiClient.post(
        '/auth/request-signup-otp', // Placeholder endpoint
        data: signupRequest.toJson(),
      );
      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 204) {
        throw ServerException(
          message: 'Requesting signup OTP failed',
          data: response.data,
        );
      }
      // Success, no body expected
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      throw ServerException(
        message: e.message ?? 'Network error during signup OTP request',
        data: e.response?.data,
      );
    }
  }

  @override
  Future<void> requestLoginOtp(OtpRequestModel loginRequest) async {
    try {
      final response = await apiClient.post(
        '/auth/request-login-otp', // Placeholder endpoint
        data:
            loginRequest
                .toJson(), // Assuming name field is optional/not present for login OTP
      );
      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 204) {
        throw ServerException(
          message: 'Requesting login OTP failed',
          data: response.data,
        );
      }
      // Success, no body expected
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      throw ServerException(
        message: e.message ?? 'Network error during login OTP request',
        data: e.response?.data,
      );
    }
  }

  @override
  Future<AuthSuccessModel> verifyOtp(
    OtpVerificationModel otpVerification,
  ) async {
    try {
      final response = await apiClient.post(
        '/auth/verify-otp',
        data: otpVerification.toJson(),
      );
      if (response.statusCode == 200 && response.data != null) {
        // Expecting a response like: { "user": {...}, "tokens": {...} }
        return AuthSuccessModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'OTP verification failed',
          data: response.data,
        );
      }
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      throw ServerException(
        message: e.message ?? 'Network error during OTP verification',
        data: e.response?.data,
      );
    }
  }

  @override
  Future<TokensModel> refreshToken(
    RefreshTokenRequestModel refreshTokenRequest,
  ) async {
    try {
      final response = await apiClient.post(
        '/auth/refresh',
        data: refreshTokenRequest.toJson(),
      );
      if (response.statusCode == 200 && response.data != null) {
        return TokensModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(message: 'Token refresh failed');
      }
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      throw ServerException(
        message: e.message ?? 'Network error during token refresh',
        data: e.response?.data,
      );
    }
  }

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
