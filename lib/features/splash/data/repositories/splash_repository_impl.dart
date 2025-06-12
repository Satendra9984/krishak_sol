import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/services/token_storage_service_impl.dart';
import 'package:bhoomi_sakti/features/splash/domain/entities/app_config.dart';
import 'package:bhoomi_sakti/features/splash/domain/repositories/splash_repository.dart';
import 'package:bhoomi_sakti/features/splash/data/datasources/splash_local_data_source.dart';
import 'package:bhoomi_sakti/features/splash/data/datasources/splash_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';

import 'package:bhoomi_sakti/common/auth/entities/auth_user_with_tokens.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource localDataSource;
  final SplashRemoteDataSource remoteDataSource;
  final TokenStorageService tokenStorageService;

  SplashRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.tokenStorageService,
  });

  @override
  Future<Either<Failure, AppConfig>> getAppConfig() async {
    try {
      final isFirst = await localDataSource.isFirstLaunch();
      final latestVersion = await remoteDataSource.getLatestVersion();
      // In real app, get current version from package_info_plus
      const currentVersion = '1.0.0';
      final isUpdateRequired = latestVersion != currentVersion;
      return Right(
        AppConfig(
          isFirstLaunch: isFirst,
          isUpdateRequired: isUpdateRequired,
          currentVersion: currentVersion,
          latestVersion: latestVersion,
        ),
      );
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkForUpdates() async {
    try {
      final latestVersion = await remoteDataSource.getLatestVersion();
      const currentVersion = '1.0.0';
      return Right(latestVersion != currentVersion);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isFirstLaunch() async {
    try {
      final result = await localDataSource.isFirstLaunch();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  /// Returns AuthUserWithTokens if authenticated, null if not authenticated
  @override
  Future<Either<Failure, AuthUserWithTokens?>> checkAuthAndGetUser() async {
    try {
      final result = await remoteDataSource.checkAuthAndGetUser();
      // result should be AuthUserWithTokens or null
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> initializeTokens() async {
    try {
      await tokenStorageService.initialize();

      return Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
