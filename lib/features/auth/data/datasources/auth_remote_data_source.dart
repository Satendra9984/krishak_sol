import 'package:bhoomi_sakti/features/auth/data/models/tokens_model.dart';
import 'package:bhoomi_sakti/features/auth/data/models/user_model.dart';
import 'package:bhoomi_sakti/features/auth/data/models/otp_request_model.dart';
import 'package:bhoomi_sakti/features/auth/data/models/otp_verification_model.dart';
import 'package:bhoomi_sakti/features/auth/data/models/refresh_token_request_model.dart';
import 'package:bhoomi_sakti/features/auth/data/models/auth_success_model.dart'; // Added import

abstract class AuthRemoteDataSource {
  Future<void> requestSignupOtp(OtpRequestModel signupRequest);
  Future<void> requestLoginOtp(OtpRequestModel loginRequest); // Assuming OtpRequestModel is suitable for login OTP request
  Future<AuthSuccessModel> verifyOtp(OtpVerificationModel otpVerification);
  Future<TokensModel> refreshToken(RefreshTokenRequestModel refreshTokenRequest);
  Future<UserModel> getCurrentUser();
}
