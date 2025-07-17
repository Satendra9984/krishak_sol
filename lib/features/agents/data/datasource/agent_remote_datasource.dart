import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/app/core/network/api_client.dart';
import 'package:bhoomi_sakti/features/agents/data/models/agent_model.dart';

abstract class AgentRemoteDataSource {
  Future<List<AgentModel>> getAgents();
}

class AgentRemoteDataSourceImpl implements AgentRemoteDataSource {
  final ApiClient apiClient; // Replace with your HTTP client (dio, http, etc.)

  AgentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<AgentModel>> getAgents() async {
    try {
      final response = await apiClient.get('/agents');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => AgentModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to load agents',
          code: response.statusCode?.toString(),
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NoInternetException();
    }
  }
}
