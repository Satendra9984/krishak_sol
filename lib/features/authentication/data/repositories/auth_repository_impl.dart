import 'package:bhoomi_sakti/app/core/services/token_storage_service_impl.dart';
import 'package:bhoomi_sakti/common/auth/data/datasource/user_profile_datasource.dart';
import 'package:bhoomi_sakti/features/authentication/data/datasources/auth_remote_data_source_impl.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/features/authentication/domain/repositories/auth_repository.dart';
import 'package:bhoomi_sakti/features/authentication/data/models/otp_request_model.dart';
import 'package:bhoomi_sakti/features/authentication/data/models/otp_verification_model.dart';
import 'package:bhoomi_sakti/features/authentication/domain/entities/auth_success_entity.dart'; // Explicit import for AuthSuccessEntity

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final UserProfileRemoteDatasource userProfileRemoteDatasource;
  // final NetworkInfo networkInfo; // Optional: for checking internet connectivity
  final TokenStorageService tokenStorageService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    // required this.networkInfo,
    required this.tokenStorageService,
    required this.userProfileRemoteDatasource,
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
      final authTokens = await remoteDataSource.verifyOtp(otpVerification);

      if (authTokens == null) {
        return Left(AuthFailure('Failed to verify OTP'));
      }
      await tokenStorageService.storeTokens(authTokens);

      final user = await userProfileRemoteDatasource.getCurrentUser();

      final authSuccessEntity = AuthSuccessEntity(
        user: user.toEntity(),
        tokens: authTokens,
      );

      return Right(authSuccessEntity);
    } on AppException catch (e) {
      return Left(ExceptionFailure(e));
    } catch (e) {
      return Left(ExceptionFailure(UnexpectedException(message: e.toString())));
    }
  }
}
