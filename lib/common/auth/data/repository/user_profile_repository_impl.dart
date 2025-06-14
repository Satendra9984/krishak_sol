import 'package:bhoomi_sakti/common/auth/data/datasource/user_profile_datasource.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import '../../entities/user_entity.dart';
import '../../repositories/user_profile_repository.dart';

// Import your remote data source as needed. Adjust the import below to match your structure.

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDatasource remoteDataSource;

  UserProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return Right(userModel.toEntity());
    } on AppException catch (e) {
      return Left(ExceptionFailure(e));
    } catch (e) {
      return Left(ExceptionFailure(UnexpectedException(message: e.toString())));
    }
  }
}
