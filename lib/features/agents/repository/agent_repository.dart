import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/features/agents/domain/agent_entity.dart';

abstract class AgentRepository {
  Future<Either<Failure, List<Agent>>> getAgents();
}
