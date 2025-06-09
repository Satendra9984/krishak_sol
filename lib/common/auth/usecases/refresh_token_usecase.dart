import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import '../entities/tokens_entity.dart';
import '../repositories/session_repository.dart';

class RefreshTokenUsecase implements FutureUseCase<TokensEntity, RefreshTokenParams> {
  final SessionRepository repository;

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
