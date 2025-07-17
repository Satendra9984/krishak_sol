import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:bhoomi_sakti/features/cart/domain/entities/cart_entity.dart';
import 'package:bhoomi_sakti/features/cart/domain/repositories/cart_repository.dart';
import 'package:bhoomi_sakti/features/products/domain/entities/product_entity.dart';
import 'package:fpdart/fpdart.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource cartLocalDataSource;

  CartRepositoryImpl(this.cartLocalDataSource);

  @override
  Stream<CartEntity> getCartStream() {
    return cartLocalDataSource.getCartStream();
  }

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    try {
      final cart = await cartLocalDataSource.getCart();
      return right(cart);
    } catch (e) {
      return left(const AppFailure('Failed to get cart'));
    }
  }

  @override
  Future<Either<Failure, void>> addProductToCart(ProductEntity product) async {
    try {
      await cartLocalDataSource.addProductToCart(product);
      return right(unit);
    } catch (e) {
      return left(const AppFailure('Failed to add product to cart'));
    }
  }

  @override
  Future<Either<Failure, void>> removeProductFromCart(String productId) async {
    try {
      await cartLocalDataSource.removeProductFromCart(productId);
      return right(unit);
    } catch (e) {
      return left(const AppFailure('Failed to remove product from cart'));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(
    String productId,
    int newQuantity,
  ) async {
    try {
      await cartLocalDataSource.updateQuantity(productId, newQuantity);
      return right(unit);
    } catch (e) {
      return left(const AppFailure('Failed to update quantity'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await cartLocalDataSource.clearCart();
      return right(unit);
    } catch (e) {
      return left(const AppFailure('Failed to clear cart'));
    }
  }
}
