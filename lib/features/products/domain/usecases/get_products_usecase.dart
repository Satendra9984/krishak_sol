import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/products/domain/entities/product_entity.dart';
import 'package:bhoomi_sakti/features/products/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetProductsUsecase implements FutureUseCase<List<ProductEntity>, NoParams> {
  final ProductRepository _productRepository;

  GetProductsUsecase(this._productRepository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) async {
    return await _productRepository.getProducts();
  }
}
