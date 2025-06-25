import 'package:bhoomi_sakti/common/app_common_providers.dart';
import 'package:bhoomi_sakti/features/products/data/datasources/product_remote_data_source_impl.dart';
import 'package:bhoomi_sakti/features/products/data/repositories/product_repository_impl.dart';
import 'package:bhoomi_sakti/features/products/domain/repositories/product_repository.dart';
import 'package:bhoomi_sakti/features/products/domain/usecases/get_products_usecase.dart';
import 'package:bhoomi_sakti/features/products/presentation/blocs/product_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return ProductRemoteDataSourceImpl(apiClient);
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  return ProductRepositoryImpl(remoteDataSource);
});

final getProductsUsecaseProvider = Provider<GetProductsUsecase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductsUsecase(repository);
});

final productBlocProvider = Provider.autoDispose<ProductBloc>((ref) {
  final getProductsUsecase = ref.watch(getProductsUsecaseProvider);
  return ProductBloc(getProductsUsecase);
});
