import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/features/onboarding/domain/repositories/onboarding_repo.dart';
import 'package:fpdart/fpdart.dart';

class CompleteOnboardingUseCase {
  final OnboardingRepository repository;

  CompleteOnboardingUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.markOnboardingAsCompleted();
  }
}
