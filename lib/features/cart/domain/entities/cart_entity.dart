import 'package:equatable/equatable.dart';
import 'package:bhoomi_sakti/features/cart/domain/entities/cart_item_entity.dart';

class CartEntity extends Equatable {
  final List<CartItemEntity> items;

  const CartEntity({
    this.items = const [],
  });

  double get totalPrice {
    return items.fold(0, (total, current) => total + (current.product.price * current.quantity));
  }

  int get totalItems {
    return items.fold(0, (total, current) => total + current.quantity);
  }

  @override
  List<Object?> get props => [items];
}
