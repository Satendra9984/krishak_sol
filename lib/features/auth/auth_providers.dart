import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/app/config/providers/core_providers.dart';
import 'package:bhoomi_sakti/app/core/network/interceptors/error_interceptor.dart';
import 'package:bhoomi_sakti/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:bhoomi_sakti/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:bhoomi_sakti/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bhoomi_sakti/features/auth/domain/repositories/auth_repository.dart';
import 'package:bhoomi_sakti/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:bhoomi_sakti/features/auth/domain/usecases/login_usecase.dart';
import 'package:bhoomi_sakti/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:bhoomi_sakti/features/auth/domain/usecases/signup_usecase.dart';
import 'package:bhoomi_sakti/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/auth_notifier/auth_notifier.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/auth_notifier/auth_state.dart';
import 'package:bhoomi_sakti/features/auth/domain/entities/user_entity.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/login_bloc.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/signup_bloc.dart'; // Added SignupBloc import
import 'package:bhoomi_sakti/features/auth/presentation/blocs/verify_otp_bloc.dart'; // Added VerifyOtpBloc import
import 'package:bhoomi_sakti/features/auth/presentation/blocs/onboarding_bloc.dart'; // Added OnboardingBloc import
import 'package:shared_preferences/shared_preferences.dart'; // Added for OnboardingBloc

// TODO: Replace with actual base URL from configuration
const String _authBaseUrl = 'YOUR_BASE_URL_HERE/api';

// Dio instance specifically for Auth related calls (without RefreshInterceptor)
final authDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: _authBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  dio.interceptors.add(ErrorInterceptor());
  // dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true)); // Optional: for debugging
  return dio;
});

// Add other feature-specific providers here

// OnboardingBloc Provider
// Note: This ideally would be in an onboarding_providers.dart if features were more separated.
final onboardingBlocProvider = Provider.autoDispose<OnboardingBloc>((ref) {
  // This will throw if SharedPreferences is not available yet.
  // Consider using a FutureProvider for SharedPreferences if it needs to be loaded async first.
  // For simplicity here, assuming it's available or will be handled by an error state.
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return OnboardingBloc(sharedPreferences: sharedPreferences);
});

// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  // This provider is overridden in main_common.dart with the actual SharedPreferences instance.
  // If accessed before main_common.dart initializes and overrides it, this would throw.
  // However, the override mechanism ensures a valid instance is provided at runtime.
  throw StateError('SharedPreferencesProvider was not overridden. Ensure SharedPreferences is initialized and provided in ProviderScope in main_common.dart');
});

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

final refreshTokenUsecaseProvider = Provider<RefreshTokenUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RefreshTokenUsecase(repository);
});

final getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUsecase(repository);
});

// AuthNotifier Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final getCurrentUserUsecase = ref.watch(getCurrentUserUsecaseProvider);
  final tokenStorageService = ref.watch(tokenStorageServiceProvider);
  // final refreshTokenUsecase = ref.watch(refreshTokenUsecaseProvider); // If needed directly by AuthNotifier
  return AuthNotifier(
    getCurrentUserUsecase: getCurrentUserUsecase,
    tokenStorageService: tokenStorageService,
    // refreshTokenUsecase: refreshTokenUsecase,
  );
});

// Current Logged In User Provider
final currentUserProvider = Provider<UserEntity?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  if (authState is Authenticated) {
    return authState.user;
  }
  return null;
});

// LoginBloc Provider
final loginBlocProvider = Provider.autoDispose<LoginBloc>((ref) {
  final loginUsecase = ref.watch(loginUsecaseProvider); // This is the correct usecase for OTP login request
  return LoginBloc(
    loginUsecase: loginUsecase,
  );
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
