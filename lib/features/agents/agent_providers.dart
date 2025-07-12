import 'package:bhoomi_sakti/app/core/providers/core_providers.dart';
import 'package:bhoomi_sakti/features/agents/data/datasource/agent_remote_datasource.dart';
import 'package:bhoomi_sakti/features/agents/data/repository/agent_repository.dart';
import 'package:bhoomi_sakti/features/agents/domain/usecases/get_agents_list_usecase.dart';
import 'package:bhoomi_sakti/features/agents/repository/agent_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _agentRemoteDataSourceProvider = Provider<AgentRemoteDataSource>(
  (ref) => AgentRemoteDataSourceImpl(apiClient: ref.read(apiClientProvider)),
);

final agentRepositoryProvider = Provider<AgentRepository>(
  (ref) => AgentRepositoryImpl(
    remoteDataSource: ref.read(_agentRemoteDataSourceProvider),
  ),
);

final getAgentsUsecaseProvider = Provider<GetAgentsListUseCase>(
  (ref) => GetAgentsListUseCase(ref.watch(agentRepositoryProvider)),
);
