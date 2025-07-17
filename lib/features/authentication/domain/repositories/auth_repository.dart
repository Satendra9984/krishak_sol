import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/features/authentication/domain/entities/auth_success_entity.dart'; // Added import

abstract class AuthRepository {
  Future<Either<Failure, void>> requestSignupOtp({
    required String name,
    required String mobileNumber,
  });

  Future<Either<Failure, void>> requestLoginOtp({required String mobileNumber});

  Future<Either<Failure, AuthSuccessEntity>> verifyOtp({
    required String mobileNumber,
    required String otp,
  });

  Future<Either<Failure, void>> resendOtp({required String mobileNumber});
}
