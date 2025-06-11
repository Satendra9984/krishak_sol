import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import '../entities/user_entity.dart';
import '../entities/tokens_entity.dart';
import '../repositories/session_repository.dart';

// Import your remote data source as needed. Adjust the import below to match your structure.
import 'package:bhoomi_sakti/features/authentication/data/datasources/auth_remote_data_source_impl.dart';
import 'package:bhoomi_sakti/common/models/refresh_token_request_model.dart';

class SessionRepositoryImpl implements SessionRepository {
  final AuthRemoteDataSource remoteDataSource;

  SessionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, TokensEntity>> refreshToken(
    String refreshToken,
  ) async {
    try {
      final refreshTokenRequest = RefreshTokenRequestModel(
        refreshToken: refreshToken,
      );
      final tokensModel = await remoteDataSource.refreshToken(
        refreshTokenRequest,
      );
      return Right(tokensModel.toEntity());
    } on AppException catch (e) {
      return Left(ExceptionFailure(e));
    } catch (e) {
      return Left(ExceptionFailure(UnexpectedException(message: e.toString())));
    }
  }

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
