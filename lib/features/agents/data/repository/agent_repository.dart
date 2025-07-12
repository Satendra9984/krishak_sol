import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/features/agents/data/datasource/agent_remote_datasource.dart';
import 'package:bhoomi_sakti/features/agents/domain/entities/agent_entity.dart';
import 'package:bhoomi_sakti/features/agents/repository/agent_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fpdart/fpdart.dart';

class AgentRepositoryImpl implements AgentRepository {
  final AgentRemoteDataSource remoteDataSource;
  // final AgentLocalDataSource localDataSource;
  // final Connectivity networkInfo; // Network connectivity checker

  AgentRepositoryImpl({
    required this.remoteDataSource,
    // required this.localDataSource,
    // required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Agent>>> getAgents() async {
    // if (await networkInfo.isConnected) {
    try {
      final remoteAgents = await remoteDataSource.getAgents();
      return Right(remoteAgents);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NoInternetException catch (e) {
      return Left(NetworkFailure(e.message));
    }
    // } else {
    //   try {
    //     final cachedAgents = await localDataSource.getCachedAgents();
    //     return Right(cachedAgents);
    //   } on CacheException catch (e) {
    //     return Left(CacheFailure(e.message));
    //   } catch (e) {
    //     return Left(UnknownFailure(e.toString()));
    //   }
    // }
  }
}
