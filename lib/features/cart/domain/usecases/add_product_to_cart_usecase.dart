import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/features/cart/domain/repositories/cart_repository.dart';
import 'package:bhoomi_sakti/features/products/domain/entities/product_entity.dart';

class AddProductToCartUsecase implements FutureUseCase<void, ProductEntity> {
  final CartRepository cartRepository;

  AddProductToCartUsecase(this.cartRepository);

  @override
  Future<Either<Failure, void>> call(ProductEntity params) async {
    return await cartRepository.addProductToCart(params);
  }
}
