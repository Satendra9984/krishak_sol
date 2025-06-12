import 'package:bhoomi_sakti/common/auth/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/splash/domain/repositories/splash_repository.dart';

/// Returns UserEntity if authenticated, null if not.
class CheckAuthAndGetUser implements FutureUseCase<UserEntity?, NoParams> {
  final SplashRepository repository;
  CheckAuthAndGetUser(this.repository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) async {
    return await repository.checkAuthAndGetUser();
  }
}
