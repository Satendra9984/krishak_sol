import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/user_profile_repository.dart';

class GetCurrentUserUsecase implements FutureUseCase<UserEntity, NoParams> {
  final UserProfileRepository repository;

  GetCurrentUserUsecase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    // TODO: Add logging and analytics hooks
    return await repository.getCurrentUser();
  }
}
