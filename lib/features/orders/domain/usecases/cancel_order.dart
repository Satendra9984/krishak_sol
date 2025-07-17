import 'package:bhoomi_sakti/features/orders/domain/entities/order.dart';
import 'package:bhoomi_sakti/features/orders/domain/repositories/order_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../app/core/error/app_failures.dart';
import '../../../../app/core/usecases/usecase.dart';

class CancelOrder implements FutureUseCase<OrderEntity, int> {
  final OrdersRepository repository;

  CancelOrder(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(int orderId) async {
    return await repository.cancelOrder(orderId);
  }
}
