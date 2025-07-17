import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/cart/domain/entities/cart_entity.dart';
import 'package:bhoomi_sakti/features/cart/domain/entities/cart_item_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/features/orders/domain/entities/order.dart';
import 'package:bhoomi_sakti/features/orders/domain/repositories/order_repository.dart';

class CreateOrderUseCase extends FutureUseCase<OrderEntity, CreateOrderParams> {
  final OrdersRepository repository;

  CreateOrderUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) async {
    return await repository.createOrder(
      cart: params.cart,
      paymentId: params.paymentId,
      agentId: params.agentId,
    );
  }
}

class CreateOrderParams extends Equatable {
  final CartEntity cart;
  final int paymentId;
  final int agentId;

  const CreateOrderParams({
    required this.cart,
    required this.paymentId,
    required this.agentId,
  });

  @override
  List<Object> get props => [cart, paymentId, agentId];
}
