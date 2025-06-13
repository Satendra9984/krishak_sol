import 'package:bhoomi_sakti/features/splash/domain/entities/app_config.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/features/splash/domain/usecases/initialize_tokens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:bhoomi_sakti/features/splash/domain/usecases/check_first_launch.dart';
import 'package:bhoomi_sakti/features/splash/domain/usecases/check_auth_and_get_user.dart';
import 'package:bhoomi_sakti/common/auth/entities/user_entity.dart';

import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  // final CheckVersion checkVersion;
  final CheckFirstLaunch checkFirstLaunch;
  final CheckAuthAndGetUser checkAuthAndGetUser;
  final InitializeTokens initializeTokens;

  SplashBloc({
    // required this.checkVersion,
    required this.checkFirstLaunch,
    required this.checkAuthAndGetUser,
    required this.initializeTokens,
  }) : super(SplashInitial()) {
    on<LoadSplashEvent>((event, emit) async {
      // emit(SplashLoading());
      // final result = await checkVersion(NoParams());
      // result.fold(
      //   (failure) => emit(SplashFailure(failure)),
      //   (config) => emit(SplashLoaded(config)),
      // );
    });

    on<AppStarted>(_onAppStarted);
  }

  Future<void> _onAppStarted(
    SplashEvent event,
    Emitter<SplashState> emit,
  ) async {
    //Show loading state
    emit(SplashLoading());

    // Initialize tokens (async operation)
    await initializeTokens(NoParams());

    // Check authentication and get user data
    final authResult = await checkAuthAndGetUser(NoParams());

    // Handle authentication failure case
    // Instead of using fold's left callback, we check directly
    if (authResult.isLeft()) {
      emit(NavigateToAuth());
      return; // Exit early - no need to continue
    }

    // Extract user data from the successful result
    // getOrElse() safely extracts the value or returns null
    final userWithTokens = authResult.getOrElse((_) => null);

    // If user exists, navigate to home
    if (userWithTokens != null) {
      emit(NavigateToHome(userWithTokens));
      return; // Exit early - we're done
    }

    // User doesn't exist, check if it's first launch
    final firstLaunchResult = await checkFirstLaunch(NoParams());

    // Handle first launch check result
    // This fold is safe because both callbacks are synchronous
    firstLaunchResult.fold((failure) => emit(SplashFailure(failure)), (
      isFirstLaunch,
    ) {
      if (isFirstLaunch) {
        emit(NavigateToOnboarding());
      } else {
        emit(NavigateToAuth());
      }
    });
  }
}
