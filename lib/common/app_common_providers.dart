import 'package:bhoomi_sakti/app/config/providers/core_providers.dart';
import 'package:bhoomi_sakti/common/providers/auth_notifier/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/common/providers/auth_notifier/auth_state.dart';
import 'package:bhoomi_sakti/common/auth/entities/user_entity.dart';
import 'package:bhoomi_sakti/features/auth/auth_providers.dart';

// AuthNotifier Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
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
