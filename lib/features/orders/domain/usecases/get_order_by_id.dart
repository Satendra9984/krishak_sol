import 'package:bhoomi_sakti/features/orders/domain/entities/order.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../app/core/error/app_failures.dart';
import '../../../../app/core/usecases/usecase.dart';
import '../repositories/order_repository.dart';

class GetOrderById implements FutureUseCase<OrderEntity, int> {
  final OrdersRepository repository;

  GetOrderById(this.repository);

  @override
  Future<Either<AppFailure, OrderEntity>> call(int orderId) async {
    return await repository.getOrderById(orderId);
  }
}
