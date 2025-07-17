import 'dart:async';
import 'package:bhoomi_sakti/features/onboarding/domain/repositories/onboarding_repo.dart';
import 'package:bhoomi_sakti/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:bhoomi_sakti/features/onboarding/domain/usecases/get_onboarding_status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final GetOnboardingStatusUseCase getOnboardingStatusUseCase;
  final CompleteOnboardingUseCase completeOnboardingUseCase;

  OnboardingBloc({
    required this.getOnboardingStatusUseCase,
    required this.completeOnboardingUseCase,
  }) : super(OnboardingInitial()) {
    on<OnboardingStarted>(_onStarted);
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingSkip>(_onSkip);
    on<OnboardingComplete>(_onComplete);
  }

  Future<bool> isOnboardingComplete(SharedPreferences prefs) async {
    final status = await getOnboardingStatusUseCase();

    return status.fold((l) => false, (r) => r.isCompleted);
  }

  Future<void> _onStarted(
    OnboardingStarted event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingInProgress(0));
  }

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingInProgress) {
      emit(OnboardingInProgress(event.pageIndex));
    }

    debugPrint('[onboarding_bloc.dart]: Page changed to ${event.pageIndex}');
  }

  Future<void> _onSkip(
    OnboardingSkip event,
    Emitter<OnboardingState> emit,
  ) async {
    await _completeOnboarding(emit);
  }

  Future<void> _onComplete(
    OnboardingComplete event,
    Emitter<OnboardingState> emit,
  ) async {
    await _completeOnboarding(emit);
  }

  Future<void> _completeOnboarding(Emitter<OnboardingState> emit) async {
    await completeOnboardingUseCase();
    emit(OnboardingCompleted());
  }
}
