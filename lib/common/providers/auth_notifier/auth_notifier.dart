import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/app/core/services/token_storage_service.dart';
import 'package:bhoomi_sakti/features/auth/domain/entities/tokens_entity.dart';
import 'package:bhoomi_sakti/features/auth/domain/entities/user_entity.dart'; // Added import
import 'package:bhoomi_sakti/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart'; // Import for NoParams
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final GetCurrentUserUsecase _getCurrentUserUsecase;
  final TokenStorageService _tokenStorageService;
  // final RefreshTokenUsecase _refreshTokenUsecase; // Optional: if direct refresh is needed outside Dio interceptor

  AuthNotifier({
    required GetCurrentUserUsecase getCurrentUserUsecase,
    required TokenStorageService tokenStorageService,
    // required RefreshTokenUsecase refreshTokenUsecase,
  }) : _getCurrentUserUsecase = getCurrentUserUsecase,
       _tokenStorageService = tokenStorageService,
       // _refreshTokenUsecase = refreshTokenUsecase,
       super(const AuthInitial()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = const AuthLoading();
    final tokens = await _tokenStorageService.getTokens();
    if (tokens != null && tokens.accessToken.isNotEmpty) {
      // Potentially validate token expiry here if not handled by refresh interceptor primarily
      final result = await _getCurrentUserUsecase.call(NoParams());
      result.fold(
        (failure) {
          // If fetching user fails (e.g. token expired, network issue), treat as unauthenticated
          // Could also be a specific AuthFailureState if we want to show an error
          _tokenStorageService
              .clearTokens(); // Clear potentially invalid tokens
          state = const Unauthenticated();
        },
        // Ensure tokens is not null here, as it was checked before calling _getCurrentUserUsecase
        (user) => state = Authenticated(user: user, tokens: tokens),
      );
    } else {
      state = const Unauthenticated();
    }
  }

  Future<void> processAuthSuccess(UserEntity user, TokensEntity tokens) async {
    state = const AuthLoading();
    await _tokenStorageService.saveTokens(tokens);
    // User data is now passed directly, no need to fetch again via _getCurrentUserUsecase
    state = Authenticated(user: user, tokens: tokens);
  }

  Future<void> loggedOut() async {
    state = const AuthLoading();
    await _tokenStorageService.clearTokens();
    state = const Unauthenticated();
  }

  /// Sets the authenticated user from splash (when tokens are already valid).
  void setAuthenticatedUser(UserEntity user, TokensEntity tokens) {
    state = Authenticated(user: user, tokens: tokens);
  }
}
