import 'package:bhoomi_sakti/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:bhoomi_sakti/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:bhoomi_sakti/features/cart/domain/repositories/cart_repository.dart';
import 'package:bhoomi_sakti/features/cart/domain/usecases/add_product_to_cart_usecase.dart';
import 'package:bhoomi_sakti/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:bhoomi_sakti/features/cart/domain/usecases/remove_product_from_cart_usecase.dart';
import 'package:bhoomi_sakti/features/cart/domain/usecases/update_cart_item_quantity_usecase.dart';
import 'package:bhoomi_sakti/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Data Layer Providers
final cartLocalDataSourceProvider = Provider<CartLocalDataSource>((ref) {
  // We return a singleton instance of the implementation
  return CartLocalDataSourceImpl();
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl(ref.watch(cartLocalDataSourceProvider));
});

// Domain Layer (Use Case) Providers
final getCartUsecaseProvider = Provider<GetCartUsecase>((ref) {
  return GetCartUsecase(ref.watch(cartRepositoryProvider));
});

final addProductToCartUsecaseProvider = Provider<AddProductToCartUsecase>((
  ref,
) {
  return AddProductToCartUsecase(ref.watch(cartRepositoryProvider));
});

final removeProductFromCartUsecaseProvider =
    Provider<RemoveProductFromCartUsecase>((ref) {
      return RemoveProductFromCartUsecase(ref.watch(cartRepositoryProvider));
    });

final updateCartItemQuantityUsecaseProvider =
    Provider<UpdateCartItemQuantityUsecase>((ref) {
      return UpdateCartItemQuantityUsecase(ref.watch(cartRepositoryProvider));
    });

// Presentation Layer (BLoC) Provider
final cartBlocProvider = Provider.autoDispose<CartBloc>((ref) {
  final cartBloc = CartBloc(
    cartRepository: ref.watch(cartRepositoryProvider),
    removeProductFromCartUsecase: ref.watch(
      removeProductFromCartUsecaseProvider,
    ),
    updateCartItemQuantityUsecase: ref.watch(
      updateCartItemQuantityUsecaseProvider,
    ),
  );

  // When the provider is destroyed, close the BLoC
  ref.onDispose(() => cartBloc.close());

  return cartBloc;
});
