import 'package:bhoomi_sakti/features/authentication/data/datasources/auth_remote_data_source_impl.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/common/auth/entities/user_entity.dart';
import 'package:bhoomi_sakti/common/auth/entities/tokens_entity.dart';
import 'package:bhoomi_sakti/features/authentication/domain/repositories/auth_repository.dart';
import 'package:bhoomi_sakti/features/authentication/data/models/otp_request_model.dart';
import 'package:bhoomi_sakti/features/authentication/data/models/otp_verification_model.dart';
import 'package:bhoomi_sakti/common/models/refresh_token_request_model.dart';
import 'package:bhoomi_sakti/features/authentication/data/models/auth_success_model.dart'; // Added import
import 'package:bhoomi_sakti/features/authentication/domain/entities/auth_success_entity.dart'; // Explicit import for AuthSuccessEntity

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  // final NetworkInfo networkInfo; // Optional: for checking internet connectivity

  AuthRepositoryImpl({
    required this.remoteDataSource,
    // required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> requestSignupOtp({
    required String name,
    required String mobileNumber,
  }) async {
    try {
      // Assuming OtpRequestModel can be used, or a new model is created if structure differs significantly.
      final signupOtpRequest = OtpRequestModel(
        mobileNumber: mobileNumber,
        name: name,
      );
      await remoteDataSource.requestSignupOtp(signupOtpRequest);
      return const Right(null);
    } on AppException catch (e) {
      return Left(ExceptionFailure(e));
    } catch (e) {
      return Left(ExceptionFailure(UnexpectedException(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> requestLoginOtp({
    required String mobileNumber,
  }) async {
    try {
      // Assuming OtpRequestModel can be used (name can be nullable or a different model is used).
      final loginOtpRequest = OtpRequestModel(mobileNumber: mobileNumber);
      await remoteDataSource.requestLoginOtp(loginOtpRequest);
      return const Right(null);
    } on AppException catch (e) {
      return Left(ExceptionFailure(e));
    } catch (e) {
      return Left(ExceptionFailure(UnexpectedException(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, AuthSuccessEntity>> verifyOtp({
    required String mobileNumber,
    required String otp,
  }) async {
    try {
      final otpVerification = OtpVerificationModel(
        mobileNumber: mobileNumber,
        otp: otp,
      );
      final AuthSuccessModel authSuccessModel = await remoteDataSource
          .verifyOtp(otpVerification);
      return Right(authSuccessModel.toEntity());
    } on AppException catch (e) {
      return Left(ExceptionFailure(e));
    } catch (e) {
      return Left(ExceptionFailure(UnexpectedException(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, TokensEntity>> refreshToken(
    String refreshToken,
  ) async {
    try {
      final refreshTokenRequest = RefreshTokenRequestModel(
        refreshToken: refreshToken,
      );
      final tokensModel = await remoteDataSource.refreshToken(
        refreshTokenRequest,
      );
      return Right(tokensModel.toEntity());
    } on AppException catch (e) {
      return Left(ExceptionFailure(e));
    } catch (e) {
      return Left(ExceptionFailure(UnexpectedException(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return Right(userModel.toEntity());
    } on AppException catch (e) {
      return Left(ExceptionFailure(e));
    } catch (e) {
      return Left(ExceptionFailure(UnexpectedException(message: e.toString())));
    }
  }
}
