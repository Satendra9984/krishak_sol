import 'package:bhoomi_sakti/features/orders/data/model/order_model.dart';
import 'package:dio/dio.dart';
import '../../../../app/core/error/app_exceptions.dart';
import '../../../../app/core/network/api_client.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderModel>> getOrders({
    int page = 1,
    int limit = 10,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  });

  Future<OrderModel> getOrderById(int orderId);
  Future<OrderModel> cancelOrder(int orderId);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final ApiClient apiClient;

  OrdersRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<OrderModel>> getOrders({
    int page = 1,
    int limit = 10,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (status != null) queryParams['status'] = status;
      if (fromDate != null)
        queryParams['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['toDate'] = toDate.toIso8601String();

      final response = await apiClient.get(
        '/orders/',
        queryParameters: queryParams,
      );

      if (response.data is List) {
        return (response.data as List)
            .map((order) => OrderModel.fromJson(order as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(message: 'Invalid response format');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to fetch orders');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<OrderModel> getOrderById(int orderId) async {
    try {
      final response = await apiClient.get('/orders/$orderId');
      return OrderModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to fetch order');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<OrderModel> cancelOrder(int orderId) async {
    try {
      final response = await apiClient.post('/orders/$orderId/cancel');
      return OrderModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to cancel order');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
