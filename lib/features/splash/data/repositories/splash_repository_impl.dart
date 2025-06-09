import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/features/splash/domain/entities/app_config.dart';
import 'package:bhoomi_sakti/features/splash/domain/repositories/splash_repository.dart';
import 'package:bhoomi_sakti/features/splash/data/datasources/local/splash_local_data_source.dart';
import 'package:bhoomi_sakti/features/splash/data/datasources/remote/version_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';

import 'package:bhoomi_sakti/features/auth/domain/entities/auth_user_with_tokens.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource localDataSource;
  final VersionRemoteDataSource remoteDataSource;

  SplashRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
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

  @override
  Future<Either<Failure, void>> setFirstLaunchComplete() async {
    try {
      await localDataSource.setFirstLaunchComplete();
      return const Right(null);
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
}
