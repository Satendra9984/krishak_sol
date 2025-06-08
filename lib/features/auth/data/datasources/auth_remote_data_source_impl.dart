import 'package:dio/dio.dart';
import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/features/auth/data/models/tokens_model.dart';
import 'package:bhoomi_sakti/features/auth/data/models/user_model.dart';
import 'package:bhoomi_sakti/features/auth/data/models/otp_request_model.dart';
import 'package:bhoomi_sakti/features/auth/data/models/otp_verification_model.dart';
import 'package:bhoomi_sakti/features/auth/data/models/refresh_token_request_model.dart';
import 'package:bhoomi_sakti/features/auth/data/models/auth_success_model.dart'; // Added import
import 'auth_remote_data_source.dart';

const String _baseUrl = 'YOUR_BASE_URL_HERE';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> requestSignupOtp(OtpRequestModel signupRequest) async {
    try {
      final response = await dio.post(
        '$_baseUrl/auth/request-signup-otp', // Placeholder endpoint
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
      final response = await dio.post(
        '$_baseUrl/auth/request-login-otp', // Placeholder endpoint
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
      final response = await dio.post(
        '$_baseUrl/auth/verify-otp',
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
      final response = await dio.post(
        '$_baseUrl/auth/refresh',
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
      final response = await dio.get('$_baseUrl/user/me');
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
