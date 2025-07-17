import 'package:bhoomi_sakti/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:bhoomi_sakti/features/onboarding/domain/repositories/onboarding_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/app/core/providers/shared_preferences_provider.dart';
import 'package:bhoomi_sakti/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bhoomi_sakti/features/onboarding/domain/usecases/get_onboarding_status.dart';
import 'package:bhoomi_sakti/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:bhoomi_sakti/features/onboarding/data/repositories/onboarding_repository_impl.dart';

final onboardingLocalDataSourceProvider =
    Provider.autoDispose<OnboardingLocalDataSource>((ref) {
      final sharedPreferences = ref.watch(sharedPreferencesSyncProvider);
      return OnboardingLocalDataSourceImpl(
        sharedPreferences: sharedPreferences,
      );
    });

final onboardingRepositoryProvider = Provider.autoDispose<OnboardingRepository>(
  (ref) {
    final localDataSource = ref.watch(onboardingLocalDataSourceProvider);
    return OnboardingRepositoryImpl(localDataSource: localDataSource);
  },
);

final getOnboardingStatusUseCaseProvider =
    Provider.autoDispose<GetOnboardingStatusUseCase>((ref) {
      final repository = ref.watch(onboardingRepositoryProvider);
      return GetOnboardingStatusUseCase(repository);
    });

final completeOnboardingUseCaseProvider =
    Provider.autoDispose<CompleteOnboardingUseCase>((ref) {
      final repository = ref.watch(onboardingRepositoryProvider);
      return CompleteOnboardingUseCase(repository);
    });

final onboardingBlocProvider = Provider.autoDispose<OnboardingBloc>((ref) {
  return OnboardingBloc(
    getOnboardingStatusUseCase: ref.watch(getOnboardingStatusUseCaseProvider),
    completeOnboardingUseCase: ref.watch(completeOnboardingUseCaseProvider),
  );
});
