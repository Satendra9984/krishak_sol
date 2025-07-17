import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/splash/domain/repositories/splash_repository.dart';
import 'package:fpdart/fpdart.dart';

class InitializeTokens implements FutureUseCase<void, NoParams> {
  final SplashRepository repository;

  InitializeTokens(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.initializeTokens();
  }
}
