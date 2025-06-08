import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final SharedPreferences sharedPreferences;
  static const String _onboardingCompleteKey = 'onboarding_complete';

  OnboardingBloc({required this.sharedPreferences}) : super(OnboardingInitial()) {
    on<OnboardingStarted>(_onStarted);
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingSkip>(_onSkip);
    on<OnboardingComplete>(_onComplete);
  }

  static Future<bool> isOnboardingComplete(SharedPreferences prefs) async {
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  Future<void> _onStarted(OnboardingStarted event, Emitter<OnboardingState> emit) async {
    emit(OnboardingInProgress(0));
  }

  void _onPageChanged(OnboardingPageChanged event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      emit(OnboardingInProgress(event.pageIndex));
    }
  }

  Future<void> _onSkip(OnboardingSkip event, Emitter<OnboardingState> emit) async {
    await _completeOnboarding(emit);
  }

  Future<void> _onComplete(OnboardingComplete event, Emitter<OnboardingState> emit) async {
    await _completeOnboarding(emit);
  }

  Future<void> _completeOnboarding(Emitter<OnboardingState> emit) async {
    await sharedPreferences.setBool(_onboardingCompleteKey, true);
    emit(OnboardingCompleted());
  }
}
