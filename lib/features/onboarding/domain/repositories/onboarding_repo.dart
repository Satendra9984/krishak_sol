import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/features/onboarding/domain/entities/onboarding_status.dart';
import 'package:fpdart/fpdart.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, void>> markOnboardingAsCompleted();
  Future<Either<Failure, OnboardingStatus>> getOnboardingStatus();
}
