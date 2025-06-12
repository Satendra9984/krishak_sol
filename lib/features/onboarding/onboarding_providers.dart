import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/app/core/providers/shared_preferences_provider.dart';
import 'package:bhoomi_sakti/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_bloc.dart';

final onboardingBlocProvider = Provider.autoDispose<OnboardingBloc>((ref) {
  final sharedPreferences =
      ref.watch(sharedPreferencesInitializerProvider).value;
  if (sharedPreferences == null) {
    throw Exception('SharedPreferences not initialized');
  }
  return OnboardingBloc(sharedPreferences: sharedPreferences);
});
