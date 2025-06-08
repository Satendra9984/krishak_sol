import 'package:bhoomi_sakti/app/core/error/failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/splash/domain/repositories/splash_repository.dart';
import 'package:fpdart/fpdart.dart';

class CheckFirstLaunch implements FutureUseCase<bool, NoParams> {
  final SplashRepository repository;

  CheckFirstLaunch(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isFirstLaunch();
  }
}
