import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/auth/domain/entities/auth_user_with_tokens.dart';
import 'package:bhoomi_sakti/features/splash/domain/repositories/splash_repository.dart';

/// Returns UserEntity if authenticated, null if not.
class CheckAuthAndGetUser implements FutureUseCase<AuthUserWithTokens?, NoParams> {
  final SplashRepository repository;
  CheckAuthAndGetUser(this.repository);

  @override
  Future<Either<Failure, AuthUserWithTokens?>> call(NoParams params) async {
    return await repository.checkAuthAndGetUser();
  }
}
