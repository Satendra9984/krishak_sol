import 'package:bhoomi_sakti/app/core/error/failures.dart';
import 'package:bhoomi_sakti/features/splash/domain/entities/app_config.dart';
import 'package:fpdart/fpdart.dart';

import 'package:bhoomi_sakti/features/auth/domain/entities/auth_user_with_tokens.dart';

abstract class SplashRepository {
  Future<Either<Failure, AppConfig>> getAppConfig();
  Future<Either<Failure, bool>> checkForUpdates();
  Future<Either<Failure, bool>> isFirstLaunch();
  Future<Either<Failure, void>> setFirstLaunchComplete();
  /// Returns AuthUserWithTokens if authenticated, null if not authenticated
  Future<Either<Failure, AuthUserWithTokens?>> checkAuthAndGetUser();
}
