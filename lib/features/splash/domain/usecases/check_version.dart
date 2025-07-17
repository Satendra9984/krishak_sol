import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/splash/domain/entities/app_config.dart';
import 'package:bhoomi_sakti/features/splash/domain/repositories/splash_repository.dart';
import 'package:fpdart/fpdart.dart';

class CheckVersion implements FutureUseCase<AppConfig, NoParams> {
  final SplashRepository repository;

  CheckVersion(this.repository);

  @override
  Future<Either<Failure, AppConfig>> call(NoParams params) async {
    return await repository.checkForUpdates().then((result) async {
      return result.fold((failure) => Left(failure), (hasUpdate) async {
        final firstLaunchResult = await repository.isFirstLaunch();
        return firstLaunchResult.fold(
          (failure) => Left(failure),
          (isFirstLaunch) => Right(
            AppConfig(
              isFirstLaunch: isFirstLaunch,
              isUpdateRequired: hasUpdate,
              currentVersion:
                  '1.0.0', // This should come from package_info_plus
              latestVersion:
                  hasUpdate ? '2.0.0' : '1.0.0', // This should come from API
            ),
          ),
        );
      });
    });
  }
}
