import 'package:bhoomi_sakti/features/cart/domain/entities/cart_item_entity.dart';

class PaymentCalculator {
  double calculateTotal(List<CartItemEntity> cartItems) {
    return cartItems.fold(
      0.0,
      (previousValue, element) =>
          previousValue + element.product.price * element.quantity,
    );
  }
}
