import 'dart:async';
import 'package:bhoomi_sakti/features/cart/domain/entities/cart_entity.dart';
import 'package:bhoomi_sakti/features/cart/domain/entities/cart_item_entity.dart';
import 'package:bhoomi_sakti/features/products/domain/entities/product_entity.dart';
import 'package:rxdart/rxdart.dart';

abstract class CartLocalDataSource {
  Stream<CartEntity> getCartStream();
  Future<CartEntity> getCart();
  Future<void> addProductToCart(ProductEntity product);
  Future<void> removeProductFromCart(String productId);
  Future<void> updateQuantity(String productId, int newQuantity);
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final _cart = BehaviorSubject<CartEntity>.seeded(const CartEntity());

  @override
  Stream<CartEntity> getCartStream() => _cart.stream;

  @override
  Future<CartEntity> getCart() async => _cart.value;

  @override
  Future<void> addProductToCart(ProductEntity product) async {
    final currentCart = _cart.value;
    final List<CartItemEntity> updatedItems = List.from(currentCart.items);

    final itemIndex = updatedItems.indexWhere(
      (item) => item.product.productId == product.productId,
    );

    if (itemIndex != -1) {
      final existingItem = updatedItems[itemIndex];
      updatedItems[itemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      updatedItems.add(CartItemEntity(product: product, quantity: 1));
    }

    _cart.add(CartEntity(items: updatedItems));
  }

  @override
  Future<void> removeProductFromCart(String productId) async {
    final currentCart = _cart.value;
    final List<CartItemEntity> updatedItems = List.from(currentCart.items);
    updatedItems.removeWhere((item) => item.product.productId == productId);
    _cart.add(CartEntity(items: updatedItems));
  }

  @override
  Future<void> updateQuantity(String productId, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeProductFromCart(productId);
      return;
    }

    final currentCart = _cart.value;
    final List<CartItemEntity> updatedItems = List.from(currentCart.items);
    final itemIndex = updatedItems.indexWhere(
      (item) => item.product.productId == productId,
    );

    if (itemIndex != -1) {
      updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(
        quantity: newQuantity,
      );
      _cart.add(CartEntity(items: updatedItems));
    }
  }
}
