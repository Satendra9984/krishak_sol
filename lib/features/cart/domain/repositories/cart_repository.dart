import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/features/cart/domain/entities/cart_entity.dart';
import 'package:bhoomi_sakti/features/products/domain/entities/product_entity.dart';

abstract class CartRepository {
  Stream<CartEntity> getCartStream();
  Future<Either<Failure, CartEntity>> getCart();
  Future<Either<Failure, void>> addProductToCart(ProductEntity product);
  Future<Either<Failure, void>> removeProductFromCart(String productId);
  Future<Either<Failure, void>> updateQuantity(
    String productId,
    int newQuantity,
  );

  Future<Either<Failure, void>> clearCart();
}
