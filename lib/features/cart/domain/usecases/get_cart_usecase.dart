import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/cart/domain/entities/cart_entity.dart';
import 'package:bhoomi_sakti/features/cart/domain/repositories/cart_repository.dart';

class GetCartUsecase implements FutureUseCase<CartEntity, NoParams> {
  final CartRepository cartRepository;

  GetCartUsecase(this.cartRepository);

  @override
  Future<Either<Failure, CartEntity>> call(NoParams params) async {
    return await cartRepository.getCart();
  }
}
