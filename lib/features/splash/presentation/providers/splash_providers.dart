import 'package:bhoomi_sakti/app/config/providers/core_providers.dart';
import 'package:bhoomi_sakti/app/core/providers/shared_preferences_provider.dart';
import 'package:bhoomi_sakti/features/splash/domain/usecases/initialize_tokens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/features/splash/domain/usecases/check_first_launch.dart';
import 'package:bhoomi_sakti/features/splash/domain/usecases/check_auth_and_get_user.dart';
import 'package:bhoomi_sakti/features/splash/domain/repositories/splash_repository.dart';
import 'package:bhoomi_sakti/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:bhoomi_sakti/features/splash/data/datasources/splash_local_data_source.dart';
import 'package:bhoomi_sakti/features/splash/data/datasources/splash_remote_data_source.dart';
import 'package:bhoomi_sakti/features/splash/presentation/blocs/splash_bloc.dart';

final _splashLocalDataSourceProvider = Provider<SplashLocalDataSource>(
  (ref) => SplashLocalDataSourceImpl(
    sharedPreferences: ref.read(sharedPreferencesProvider),
  ),
);
final _versionRemoteDataSourceProvider = Provider<SplashRemoteDataSource>(
  (ref) => SplashRemoteDataSourceImpl(ref.read(apiClientProvider)),
);

final _splashRepositoryProvider = Provider<SplashRepository>((ref) {
  return SplashRepositoryImpl(
    localDataSource: ref.read(_splashLocalDataSourceProvider),
    remoteDataSource: ref.read(_versionRemoteDataSourceProvider),
    tokenStorageService: ref.read(tokenStorageServiceProvider),
  );
});

// final _checkVersionProvider = Provider<CheckVersion>((ref) {
//   return CheckVersion(ref.read(_splashRepositoryProvider));
// });

final _checkFirstLaunchProvider = Provider<CheckFirstLaunch>((ref) {
  return CheckFirstLaunch(ref.read(_splashRepositoryProvider));
});

final _checkAuthAndGetUserProvider = Provider<CheckAuthAndGetUser>((ref) {
  return CheckAuthAndGetUser(ref.read(_splashRepositoryProvider));
});

final _initializeTokensProvider = Provider<InitializeTokens>((ref) {
  return InitializeTokens(ref.read(_splashRepositoryProvider));
});

final splashBlocProvider = Provider<SplashBloc>((ref) {
  return SplashBloc(
    // checkVersion: ref.read(checkVersionProvider),
    checkFirstLaunch: ref.read(_checkFirstLaunchProvider),
    checkAuthAndGetUser: ref.read(_checkAuthAndGetUserProvider),
    initializeTokens: ref.read(_initializeTokensProvider),
  );
});
