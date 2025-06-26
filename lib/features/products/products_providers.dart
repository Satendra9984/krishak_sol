import 'package:bhoomi_sakti/common/app_common_providers.dart';
import 'package:bhoomi_sakti/features/products/data/datasources/product_remote_data_source_impl.dart';
import 'package:bhoomi_sakti/features/products/data/repositories/product_repository_impl.dart';
import 'package:bhoomi_sakti/features/products/domain/entities/product_entity.dart';
import 'package:bhoomi_sakti/features/products/domain/repositories/product_repository.dart';
import 'package:bhoomi_sakti/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Data Source Provider
final productRemoteDataSourceProvider =
    Provider<ProductRemoteDataSource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return ProductRemoteDataSourceImpl(dio);
});

/// Repository Provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  return ProductRepositoryImpl(remoteDataSource);
});

/// Usecase Providers
final getProductByIdUsecaseProvider = Provider<GetProductByIdUsecase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductByIdUsecase(repository);
});

/// UI-facing Provider for Product Details
final productDetailsProvider =
    FutureProvider.family<ProductEntity, String>((ref, productId) async {
  final getProductById = ref.watch(getProductByIdUsecaseProvider);
  final result = await getProductById.call(GetProductByIdParams(productId: productId));
  return result.fold(
    (failure) => throw failure.message,
    (product) => product,
  );
});
