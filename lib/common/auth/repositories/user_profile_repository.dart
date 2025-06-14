import 'package:fpdart/fpdart.dart';
import '../entities/user_entity.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserEntity>> getCurrentUser();
}
