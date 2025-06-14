import 'package:bhoomi_sakti/app/core/network/api_client.dart';
import 'package:bhoomi_sakti/common/auth/entities/tokens_entity.dart';
import 'package:dio/dio.dart';
import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/features/authentication/data/models/otp_request_model.dart';
import 'package:bhoomi_sakti/features/authentication/data/models/otp_verification_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> requestSignupOtp(OtpRequestModel signupRequest);
  Future<void> requestLoginOtp(OtpRequestModel loginRequest);
  Future<TokensEntity?> verifyOtp(OtpVerificationModel otpVerification);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> requestSignupOtp(OtpRequestModel signupRequest) async {
    try {
      final response = await apiClient.post(
        '/auth/signup', // Placeholder endpoint
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
        '/auth/login', // Placeholder endpoint
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
  Future<TokensEntity?> verifyOtp(OtpVerificationModel otpVerification) async {
    try {
      final response = await apiClient.post(
        '/auth/verify-otp',
        data: otpVerification.toJson(),
      );
      if (response.statusCode == 200 && response.data != null) {
        return TokensEntity.fromJson(response.data as Map<String, dynamic>);
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
}
