import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDataSource {
  Future<bool> isOnboardingCompleted();
  Future<void> setOnboardingCompleted();
}

// lib/features/onboarding/data/datasources/onboarding_local_datasource_impl.dart
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _onboardingCompleteKey = 'first_launch';

  OnboardingLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> isOnboardingCompleted() async {
    return sharedPreferences.getBool(_onboardingCompleteKey) ?? false;
  }

  @override
  Future<void> setOnboardingCompleted() async {
    await sharedPreferences.setBool(_onboardingCompleteKey, false);
  }
}
