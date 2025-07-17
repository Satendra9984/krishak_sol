import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/authentication/domain/repositories/auth_repository.dart';
import 'package:bhoomi_sakti/features/authentication/domain/entities/auth_success_entity.dart'; // Added import

class VerifyOtpUsecase
    implements FutureUseCase<AuthSuccessEntity, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUsecase(this.repository);

  @override
  Future<Either<Failure, AuthSuccessEntity>> call(
    VerifyOtpParams params,
  ) async {
    // TODO: Add logging and analytics hooks
    return await repository.verifyOtp(
      mobileNumber: params.mobileNumber,
      otp: params.otp,
    );
  }
}

class VerifyOtpParams {
  final String mobileNumber;
  final String otp;

  VerifyOtpParams({required this.mobileNumber, required this.otp});
}
