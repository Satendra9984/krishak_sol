import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/authentication/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ResendOtpUsecase implements FutureUseCase<void, String> {
  final AuthRepository authRepository;

  ResendOtpUsecase({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(String params) async {
    return authRepository.resendOtp(mobileNumber: params);
  }
}
