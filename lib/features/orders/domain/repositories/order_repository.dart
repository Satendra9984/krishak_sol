import 'package:bhoomi_sakti/features/cart/domain/entities/cart_entity.dart';
import 'package:bhoomi_sakti/features/orders/domain/entities/order.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../app/core/error/app_failures.dart';

abstract class OrdersRepository {
  Future<Either<Failure, OrderEntity>> createOrder({
    required CartEntity cart,
    required int paymentId,
    required int agentId,
  });

  Future<Either<Failure, List<OrderEntity>>> getOrders({
    int page = 1,
    int limit = 10,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  });

  Future<Either<Failure, OrderEntity>> getOrderById(int orderId);

  Future<Either<Failure, OrderEntity>> cancelOrder(int orderId);

  Future<Either<Failure, List<OrderEntity>>> reorderItems(int orderId);
}
