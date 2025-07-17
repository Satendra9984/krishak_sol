import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bhoomi_sakti/features/cart/domain/entities/cart_entity.dart';
import 'package:bhoomi_sakti/features/cart/domain/repositories/cart_repository.dart';
import 'package:bhoomi_sakti/features/cart/domain/usecases/remove_product_from_cart_usecase.dart';
import 'package:bhoomi_sakti/features/cart/domain/usecases/update_cart_item_quantity_usecase.dart';
import 'package:equatable/equatable.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  final RemoveProductFromCartUsecase _removeProductFromCartUsecase;
  final UpdateCartItemQuantityUsecase _updateCartItemQuantityUsecase;
  StreamSubscription<CartEntity>? _cartSubscription;

  CartBloc({
    required CartRepository cartRepository,
    required RemoveProductFromCartUsecase removeProductFromCartUsecase,
    required UpdateCartItemQuantityUsecase updateCartItemQuantityUsecase,
  })  : _cartRepository = cartRepository,
        _removeProductFromCartUsecase = removeProductFromCartUsecase,
        _updateCartItemQuantityUsecase = updateCartItemQuantityUsecase,
        super(CartLoading()) {
    on<LoadCart>(_onLoadCart);
    on<CartUpdated>(_onCartUpdated);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);

    _cartSubscription = _cartRepository.getCartStream().listen((cart) {
      add(CartUpdated(cart));
    });
  }

  void _onLoadCart(LoadCart event, Emitter<CartState> emit) {
    // Initial load can be handled by the stream, but you could also fetch here.
  }

  void _onCartUpdated(CartUpdated event, Emitter<CartState> emit) {
    emit(CartLoaded(event.cart));
  }

  Future<void> _onRemoveItemFromCart(
      RemoveItemFromCart event, Emitter<CartState> emit) async {
    await _removeProductFromCartUsecase.call(event.productId);
  }

  Future<void> _onUpdateItemQuantity(
      UpdateItemQuantity event, Emitter<CartState> emit) async {
    await _updateCartItemQuantityUsecase.call(
      UpdateCartItemQuantityParams(
        productId: event.productId,
        newQuantity: event.newQuantity,
      ),
    );
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}
