import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/products/domain/entities/product_entity.dart';
import 'package:bhoomi_sakti/features/products/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetProductByIdUsecase
    implements FutureUseCase<ProductEntity, GetProductByIdParams> {
  final ProductRepository productRepository;

  GetProductByIdUsecase(this.productRepository);

  @override
  Future<Either<Failure, ProductEntity>> call(GetProductByIdParams params) {
    return productRepository.getProductById(params.productId);
  }
}

class GetProductByIdParams {
  final String productId;

  GetProductByIdParams({required this.productId});
}
