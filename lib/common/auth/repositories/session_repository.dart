import 'package:fpdart/fpdart.dart';
import '../entities/user_entity.dart';
import '../entities/tokens_entity.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';

abstract class SessionRepository {
  Future<Either<Failure, TokensEntity>> refreshToken(String refreshToken);
  Future<Either<Failure, UserEntity>> getCurrentUser();
}
