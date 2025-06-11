import 'package:bhoomi_sakti/app/core/providers/shared_preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/features/splash/domain/usecases/check_version.dart';
import 'package:bhoomi_sakti/features/splash/domain/usecases/check_first_launch.dart';
import 'package:bhoomi_sakti/features/splash/domain/usecases/check_auth_and_get_user.dart';
import 'package:bhoomi_sakti/features/splash/domain/repositories/splash_repository.dart';
import 'package:bhoomi_sakti/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:bhoomi_sakti/features/splash/data/datasources/local/splash_local_data_source.dart';
import 'package:bhoomi_sakti/features/splash/data/datasources/remote/splash_remote_data_source.dart';
import 'package:bhoomi_sakti/features/splash/presentation/blocs/splash_bloc.dart';

final splashLocalDataSourceProvider = Provider<SplashLocalDataSource>(
  (ref) => SplashLocalDataSourceImpl(
    sharedPreferences: ref.read(sharedPreferencesProvider),
  ),
);
final versionRemoteDataSourceProvider = Provider<SplashRemoteDataSource>(
  (ref) => SplashRemoteDataSourceImpl(),
);

final splashRepositoryProvider = Provider<SplashRepository>((ref) {
  return SplashRepositoryImpl(
    localDataSource: ref.read(splashLocalDataSourceProvider),
    remoteDataSource: ref.read(versionRemoteDataSourceProvider),
  );
});

final checkVersionProvider = Provider<CheckVersion>((ref) {
  return CheckVersion(ref.read(splashRepositoryProvider));
});

final checkFirstLaunchProvider = Provider<CheckFirstLaunch>((ref) {
  return CheckFirstLaunch(ref.read(splashRepositoryProvider));
});

final checkAuthAndGetUserProvider = Provider<CheckAuthAndGetUser>((ref) {
  return CheckAuthAndGetUser(ref.read(splashRepositoryProvider));
});

final splashBlocProvider = Provider<SplashBloc>((ref) {
  return SplashBloc(
    // checkVersion: ref.read(checkVersionProvider),
    checkFirstLaunch: ref.read(checkFirstLaunchProvider),
    checkAuthAndGetUser: ref.read(checkAuthAndGetUserProvider),
  );
});
