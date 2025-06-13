import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:bhoomi_sakti/features/onboarding/domain/entities/onboarding_status.dart';
import 'package:bhoomi_sakti/features/onboarding/domain/repositories/onboarding_repo.dart';
import 'package:fpdart/fpdart.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> markOnboardingAsCompleted() async {
    try {
      await localDataSource.setOnboardingCompleted();

      return Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, OnboardingStatus>> getOnboardingStatus() async {
    try {
      final isCompleted = await localDataSource.isOnboardingCompleted();
      return Right(
        OnboardingStatus(
          isCompleted: isCompleted,
          currentPage: 0, // Default to first page
        ),
      );
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
