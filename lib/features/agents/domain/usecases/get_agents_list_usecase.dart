// lib/domain/usecases/get_agents_usecase.dart
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/agents/domain/entities/agent_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/features/agents/repository/agent_repository.dart';

class GetAgentsListUseCase implements FutureUseCase<List<Agent>, NoParams> {
  final AgentRepository repository;

  GetAgentsListUseCase(this.repository);

  @override
  Future<Either<Failure, List<Agent>>> call(NoParams params) async {
    return await repository.getAgents();
  }
}
