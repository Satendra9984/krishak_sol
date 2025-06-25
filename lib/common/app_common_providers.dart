export 'package:bhoomi_sakti/app/core/providers/core_providers.dart';
import 'package:bhoomi_sakti/app/core/providers/core_providers.dart';
import 'package:bhoomi_sakti/common/auth/data/datasource/user_profile_datasource.dart';
import 'package:bhoomi_sakti/common/auth/data/repository/user_profile_repository_impl.dart';
import 'package:bhoomi_sakti/common/auth/usecases/get_current_user_usecase.dart';
import 'package:bhoomi_sakti/common/providers/auth_notifier/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/common/providers/auth_notifier/auth_state.dart';
import 'package:bhoomi_sakti/common/auth/entities/user_entity.dart';

final userProfileRemoteDatasourceProvider = Provider((ref) {
  return UserProfileRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepositoryImpl(
    remoteDataSource: ref.watch(userProfileRemoteDatasourceProvider),
  );
});

final getCurrentUserUsecaseProvider = Provider((ref) {
  return GetCurrentUserUsecase(ref.watch(userProfileRepositoryProvider));
});

// AuthNotifier Provider
final authNotifierProvider = StateNotifierProvider<
  UserAccountNotifier,
  AuthState
>((ref) {
  final getCurrentUserUsecase = ref.watch(getCurrentUserUsecaseProvider);
  final tokenStorageService = ref.watch(tokenStorageServiceProvider);
  // final refreshTokenUsecase = ref.watch(refreshTokenUsecaseProvider); // If needed directly by AuthNotifier
  return UserAccountNotifier(
    getCurrentUserUsecase: getCurrentUserUsecase,
    tokenStorageService: tokenStorageService,
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
