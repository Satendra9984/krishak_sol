import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/auth/domain/entities/tokens_entity.dart';
import 'package:bhoomi_sakti/features/auth/domain/repositories/auth_repository.dart';

class RefreshTokenUsecase implements FutureUseCase<TokensEntity, RefreshTokenParams> {
  final AuthRepository repository;

  RefreshTokenUsecase(this.repository);

  @override
  Future<Either<Failure, TokensEntity>> call(RefreshTokenParams params) async {
    // TODO: Add logging and analytics hooks
    return await repository.refreshToken(params.refreshToken);
  }
}

class RefreshTokenParams {
  final String refreshToken;

  RefreshTokenParams({required this.refreshToken});
}
