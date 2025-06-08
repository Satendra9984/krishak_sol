import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/features/splash/domain/usecases/check_version.dart';
import 'package:bhoomi_sakti/features/splash/domain/usecases/check_first_launch.dart';
import 'package:bhoomi_sakti/features/splash/domain/usecases/check_auth_and_get_user.dart';
import 'package:bhoomi_sakti/features/splash/domain/repositories/splash_repository.dart';
import 'package:bhoomi_sakti/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:bhoomi_sakti/features/splash/data/datasources/local/splash_local_data_source.dart';
import 'package:bhoomi_sakti/features/splash/data/datasources/remote/version_remote_data_source.dart';
import 'package:bhoomi_sakti/features/splash/presentation/blocs/splash_bloc.dart';

import 'package:bhoomi_sakti/features/splash/data/datasources/local/splash_local_data_source_impl.dart' as local_impl;
import 'package:bhoomi_sakti/features/splash/data/datasources/remote/version_remote_data_source_impl.dart' as remote_impl;

final splashLocalDataSourceProvider = Provider<SplashLocalDataSource>((ref) => local_impl.SplashLocalDataSourceImpl());
final versionRemoteDataSourceProvider = Provider<VersionRemoteDataSource>((ref) => remote_impl.VersionRemoteDataSourceImpl());

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
    checkVersion: ref.read(checkVersionProvider),
    checkFirstLaunch: ref.read(checkFirstLaunchProvider),
    checkAuthAndGetUser: ref.read(checkAuthAndGetUserProvider),
  );
});
