import 'package:bhoomi_sakti/features/orders/domain/entities/order.dart';
import 'package:bhoomi_sakti/features/orders/domain/repositories/order_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../app/core/error/app_failures.dart';
import '../../../../app/core/usecases/usecase.dart';

class GetOrdersParams {
  final int page;
  final int limit;
  final String? status;
  final DateTime? fromDate;
  final DateTime? toDate;

  GetOrdersParams({
    this.page = 1,
    this.limit = 10,
    this.status,
    this.fromDate,
    this.toDate,
  });
}

class GetOrders implements FutureUseCase<List<OrderEntity>, GetOrdersParams> {
  final OrdersRepository repository;

  GetOrders(this.repository);

  @override
  Future<Either<AppFailure, List<OrderEntity>>> call(
    GetOrdersParams params,
  ) async {
    return await repository.getOrders(
      page: params.page,
      limit: params.limit,
      status: params.status,
      fromDate: params.fromDate,
      toDate: params.toDate,
    );
  }
}
