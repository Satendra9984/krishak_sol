import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartItemQuantityUsecase
    implements FutureUseCase<void, UpdateCartItemQuantityParams> {
  final CartRepository cartRepository;

  UpdateCartItemQuantityUsecase(this.cartRepository);

  @override
  Future<Either<Failure, void>> call(
    UpdateCartItemQuantityParams params,
  ) async {
    return await cartRepository.updateQuantity(
      params.productId,
      params.newQuantity,
    );
  }
}

class UpdateCartItemQuantityParams extends Equatable {
  final String productId;
  final int newQuantity;

  const UpdateCartItemQuantityParams({
    required this.productId,
    required this.newQuantity,
  });

  @override
  List<Object?> get props => [productId, newQuantity];
}
