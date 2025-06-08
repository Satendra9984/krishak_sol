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
  })  : _getCurrentUserUsecase = getCurrentUserUsecase,
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
          _tokenStorageService.clearTokens(); // Clear potentially invalid tokens
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
    // TODO: Potentially call an API endpoint to invalidate server-side session/token if available
  }

  // Example of how a direct refresh might be initiated if needed, though primarily handled by interceptor
  // Future<void> attemptTokenRefresh() async {
  //   if (state is Authenticated || state is AuthFailureState) { // Only if there was a user or a failed attempt
  //     final currentTokens = await _tokenStorageService.getTokens();
  //     if (currentTokens?.refreshToken != null) {
  //       final result = await _refreshTokenUsecase.call(RefreshTokenParams(refreshToken: currentTokens!.refreshToken));
  //       result.fold(
  //         (failure) async {
  //           await loggedOut(); // If refresh fails, log out fully
  //         },
  //         (newTokens) async {
  //           await _tokenStorageService.saveTokens(newTokens);
  //           // Re-fetch user or update state as Authenticated if user data is still valid
  //           final userResult = await _getCurrentUserUsecase.call(NoParams());
  //           userResult.fold(
  //             (f) => loggedOut(), 
  //             (u) => state = Authenticated(user: u)
  //           );
  //         }
  //       );
  //     } else {
  //       await loggedOut();
  //     }
  //   }
  // }
}
