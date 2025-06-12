import 'package:bhoomi_sakti/common/auth/entities/tokens_entity.dart';
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
    emit(SplashLoading());

    await initializeTokens(NoParams());

    // Not first launch, check auth and get user
    final authResult = await checkAuthAndGetUser(NoParams());
    authResult.fold(
      (failure) {
        emit(NavigateToAuth());
      },
      (userWithTokens) async {
        if (userWithTokens != null) {
          emit(NavigateToHome(userWithTokens));
        } else {
          final firstLaunchResult = await checkFirstLaunch(NoParams());
          await firstLaunchResult.fold(
            (failure) async {
              emit(SplashFailure(failure));
            },
            (isFirstLaunch) async {
              if (isFirstLaunch) {
                emit(NavigateToOnboarding());
                return;
              }
              emit(NavigateToAuth());
            },
          );
        }
      },
    );
  }
}
