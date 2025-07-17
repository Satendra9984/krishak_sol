import 'package:bhoomi_sakti/features/products/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final int orderItemId;
  final int quantity;
  final ProductEntity product;

  const OrderItem({
    required this.orderItemId,
    required this.quantity,
    required this.product,
  });

  double get totalPrice => quantity * product.price;

  @override
  List<Object?> get props => [orderItemId, quantity, product];
}
