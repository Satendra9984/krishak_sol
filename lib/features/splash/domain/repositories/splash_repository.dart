import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/common/auth/entities/user_entity.dart'
    show UserEntity;
import 'package:bhoomi_sakti/features/splash/domain/entities/app_config.dart';
import 'package:fpdart/fpdart.dart';

abstract class SplashRepository {
  /// Returns AuthUserWithTokens if authenticated, null if not authenticated
  Future<Either<Failure, UserEntity?>> checkAuthAndGetUser();

  Future<Either<Failure, bool>> isFirstLaunch();
  Future<Either<Failure, AppConfig>> getAppConfig();
  Future<Either<Failure, bool>> checkForUpdates();

  Future<Either<Failure, void>> initializeTokens();
}
