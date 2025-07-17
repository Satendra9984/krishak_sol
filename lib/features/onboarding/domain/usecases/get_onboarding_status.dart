import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/features/onboarding/domain/entities/onboarding_status.dart';
import 'package:bhoomi_sakti/features/onboarding/domain/repositories/onboarding_repo.dart';
import 'package:fpdart/fpdart.dart';

class GetOnboardingStatusUseCase {
  final OnboardingRepository repository;

  GetOnboardingStatusUseCase(this.repository);

  Future<Either<Failure, OnboardingStatus>> call() async {
    return await repository.getOnboardingStatus();
  }
}
