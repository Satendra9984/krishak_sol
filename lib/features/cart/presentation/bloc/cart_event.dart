part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class CartUpdated extends CartEvent {
  final CartEntity cart;

  const CartUpdated(this.cart);

  @override
  List<Object> get props => [cart];
}

class RemoveItemFromCart extends CartEvent {
  final String productId;

  const RemoveItemFromCart(this.productId);

  @override
  List<Object> get props => [productId];
}

class UpdateItemQuantity extends CartEvent {
  final String productId;
  final int newQuantity;

  const UpdateItemQuantity({required this.productId, required this.newQuantity});

  @override
  List<Object> get props => [productId, newQuantity];
}
