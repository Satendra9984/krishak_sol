import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/cart/domain/repositories/cart_repository.dart';

class RemoveProductFromCartUsecase implements FutureUseCase<void, String> {
  final CartRepository cartRepository;

  RemoveProductFromCartUsecase(this.cartRepository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await cartRepository.removeProductFromCart(params);
  }
}
