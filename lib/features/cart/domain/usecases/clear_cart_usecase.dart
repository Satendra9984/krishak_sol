import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/cart/domain/repositories/cart_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';

class ClearCartUsecase implements FutureUseCase<void, NoParams> {
  final CartRepository cartRepository;

  ClearCartUsecase(this.cartRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await cartRepository.clearCart();
  }
}
