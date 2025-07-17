import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/authentication/domain/repositories/auth_repository.dart';

class SignupUsecase implements FutureUseCase<void, SignupParams> {
  final AuthRepository repository;

  SignupUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(SignupParams params) async {
    // TODO: Add logging and analytics hooks
    return await repository.requestSignupOtp(
      mobileNumber: params.mobileNumber,
      name: params.name,
    );
  }
}

class SignupParams {
  final String mobileNumber;
  final String name;

  SignupParams({required this.mobileNumber, required this.name});
}
