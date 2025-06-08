import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

const String _onboardingCompleteKey = 'onboarding_complete_key';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final SharedPreferences sharedPreferences;

  OnboardingBloc({required this.sharedPreferences})
      : super(const OnboardingInProgress(0)) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingSkip>(_onSkip);
    on<OnboardingFinish>(_onFinish);
  }

  void _onPageChanged(OnboardingPageChanged event, Emitter<OnboardingState> emit) {
    emit(OnboardingInProgress(event.pageIndex));
  }

  Future<void> _onSkip(OnboardingSkip event, Emitter<OnboardingState> emit) async {
    await sharedPreferences.setBool(_onboardingCompleteKey, true);
    emit(OnboardingCompleted());
  }

  Future<void> _onFinish(OnboardingFinish event, Emitter<OnboardingState> emit) async {
    await sharedPreferences.setBool(_onboardingCompleteKey, true);
    emit(OnboardingCompleted());
  }

  static Future<bool> isOnboardingComplete(SharedPreferences prefs) async {
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }
}
