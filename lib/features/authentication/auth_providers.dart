import 'package:bhoomi_sakti/app/core/providers/core_providers.dart';
import 'package:bhoomi_sakti/common/app_common_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/features/authentication/data/datasources/auth_remote_data_source_impl.dart';
import 'package:bhoomi_sakti/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:bhoomi_sakti/features/authentication/domain/repositories/auth_repository.dart';
import 'package:bhoomi_sakti/features/authentication/domain/usecases/login_usecase.dart';
import 'package:bhoomi_sakti/features/authentication/domain/usecases/signup_usecase.dart';
import 'package:bhoomi_sakti/features/authentication/domain/usecases/verify_otp_usecase.dart';

import 'package:bhoomi_sakti/features/authentication/presentation/blocs/login/login_bloc.dart';
import 'package:bhoomi_sakti/features/authentication/presentation/blocs/signup/signup_bloc.dart'; // Added SignupBloc import
import 'package:bhoomi_sakti/features/authentication/presentation/blocs/otp_verification/verify_otp_bloc.dart'; // Added VerifyOtpBloc import

// AuthRemoteDataSource Provider
final _authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return AuthRemoteDataSourceImpl(apiClient: dio);
});

// AuthRepository Provider
final _authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(_authRemoteDataSourceProvider);
  // final networkInfo = ref.watch(networkInfoProvider); // If network info is needed
  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    userProfileRemoteDatasource: ref.watch(userProfileRemoteDatasourceProvider),
    tokenStorageService: ref.watch(tokenStorageServiceProvider),
  );
});

// Usecase Providers
final _signupUsecaseProvider = Provider<SignupUsecase>((ref) {
  final repository = ref.watch(_authRepositoryProvider);
  return SignupUsecase(repository);
});

final _loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final repository = ref.watch(_authRepositoryProvider);
  return LoginUsecase(repository);
});

final _verifyOtpUsecaseProvider = Provider<VerifyOtpUsecase>((ref) {
  final repository = ref.watch(_authRepositoryProvider);
  return VerifyOtpUsecase(repository);
});

// final _getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
//   final repository = ref.watch(_authRepositoryProvider);
//   return GetCurrentUserUsecase(repository);
// });

// LoginBloc Provider
final loginBlocProvider = Provider.autoDispose<LoginBloc>((ref) {
  final loginUsecase = ref.watch(
    _loginUsecaseProvider,
  ); // This is the correct usecase for OTP login request
  return LoginBloc(loginUsecase: loginUsecase);
});

// SignupBloc Provider
final signupBlocProvider = Provider.autoDispose<SignupBloc>((ref) {
  final signupUsecase = ref.watch(_signupUsecaseProvider);
  return SignupBloc(signupUsecase: signupUsecase);
});

// VerifyOtpBloc Provider
final verifyOtpBlocProvider = Provider.autoDispose<VerifyOtpBloc>((ref) {
  final verifyOtpUsecase = ref.watch(_verifyOtpUsecaseProvider);
  final authNotifier = ref.watch(authNotifierProvider.notifier);
  return VerifyOtpBloc(
    verifyOtpUsecase: verifyOtpUsecase,
    authNotifier: authNotifier,
  );
});
