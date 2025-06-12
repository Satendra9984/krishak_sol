import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/authentication/domain/repositories/auth_repository.dart';

class LoginUsecase implements FutureUseCase<void, LoginParams> {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(LoginParams params) async {
    // TODO: Add logging and analytics hooks
    return await repository.requestLoginOtp(mobileNumber: params.mobileNumber);
  }
}

class LoginParams {
  final String mobileNumber;

  LoginParams({required this.mobileNumber});
}
