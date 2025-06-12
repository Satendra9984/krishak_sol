import 'package:bhoomi_sakti/common/app_common_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/app/core/network/interceptors/error_interceptor.dart';
import 'package:bhoomi_sakti/features/authentication/data/datasources/auth_remote_data_source_impl.dart';
import 'package:bhoomi_sakti/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:bhoomi_sakti/features/authentication/domain/repositories/auth_repository.dart';
import 'package:bhoomi_sakti/features/authentication/domain/usecases/get_current_user_usecase.dart';
import 'package:bhoomi_sakti/features/authentication/domain/usecases/login_usecase.dart';
import 'package:bhoomi_sakti/features/authentication/domain/usecases/signup_usecase.dart';
import 'package:bhoomi_sakti/features/authentication/domain/usecases/verify_otp_usecase.dart';

import 'package:bhoomi_sakti/features/authentication/presentation/blocs/login/login_bloc.dart';
import 'package:bhoomi_sakti/features/authentication/presentation/blocs/signup/signup_bloc.dart'; // Added SignupBloc import
import 'package:bhoomi_sakti/features/authentication/presentation/blocs/otp_verification/verify_otp_bloc.dart'; // Added VerifyOtpBloc import

// TODO: Replace with actual base URL from configuration
const String _authBaseUrl = 'YOUR_BASE_URL_HERE/api';

// Dio instance specifically for Auth related calls (without RefreshInterceptor)
final authDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: _authBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  dio.interceptors.add(ErrorInterceptor());
  // dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true)); // Optional: for debugging
  return dio;
});

// Add other feature-specific providers here

// AuthRemoteDataSource Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(authDioProvider);
  return AuthRemoteDataSourceImpl(dio: dio);
});

// AuthRepository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  // final networkInfo = ref.watch(networkInfoProvider); // If network info is needed
  return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Usecase Providers
final signupUsecaseProvider = Provider<SignupUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignupUsecase(repository);
});

final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUsecase(repository);
});

final verifyOtpUsecaseProvider = Provider<VerifyOtpUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return VerifyOtpUsecase(repository);
});

final getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUsecase(repository);
});

// LoginBloc Provider
final loginBlocProvider = Provider.autoDispose<LoginBloc>((ref) {
  final loginUsecase = ref.watch(
    loginUsecaseProvider,
  ); // This is the correct usecase for OTP login request
  return LoginBloc(loginUsecase: loginUsecase);
});

// SignupBloc Provider
final signupBlocProvider = Provider.autoDispose<SignupBloc>((ref) {
  final signupUsecase = ref.watch(signupUsecaseProvider);
  return SignupBloc(signupUsecase: signupUsecase);
});

// VerifyOtpBloc Provider
final verifyOtpBlocProvider = Provider.autoDispose<VerifyOtpBloc>((ref) {
  final verifyOtpUsecase = ref.watch(verifyOtpUsecaseProvider);
  final authNotifier = ref.watch(authNotifierProvider.notifier);
  return VerifyOtpBloc(
    verifyOtpUsecase: verifyOtpUsecase,
    authNotifier: authNotifier,
  );
});
