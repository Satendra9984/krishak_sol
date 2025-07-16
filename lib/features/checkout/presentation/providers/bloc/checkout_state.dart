part of 'checkout_bloc.dart';

sealed class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitialState extends CheckoutState {
  const CheckoutInitialState();
}

class CheckoutLoadingState extends CheckoutState {
  const CheckoutLoadingState();
}

class CheckoutLoadedState extends CheckoutState {
  final List<CartItemEntity> cartItems;
  final double totalAmount;
  final PaymentMode? selectedPaymentMode;
  final int? selectedAgentId;

  const CheckoutLoadedState({
    required this.cartItems,
    required this.totalAmount,
    this.selectedPaymentMode,
    this.selectedAgentId,
  });

  @override
  List<Object?> get props => [
    cartItems,
    totalAmount,
    selectedPaymentMode,
    selectedAgentId,
  ];

  CheckoutLoadedState copyWith({
    List<CartItemEntity>? cartItems,
    double? totalAmount,
    PaymentMode? selectedPaymentMode,
    int? selectedAgentId,
  }) {
    return CheckoutLoadedState(
      cartItems: cartItems ?? this.cartItems,
      totalAmount: totalAmount ?? this.totalAmount,
      selectedPaymentMode: selectedPaymentMode ?? this.selectedPaymentMode,
      selectedAgentId: selectedAgentId ?? this.selectedAgentId,
    );
  }
}

class CheckoutPaymentCreatingState extends CheckoutState {
  const CheckoutPaymentCreatingState();
}

class CheckoutPaymentCreatedState extends CheckoutState {
  final PaymentEntity payment;

  const CheckoutPaymentCreatedState({required this.payment});

  @override
  List<Object?> get props => [payment];
}

class CheckoutOnlinePaymentInProgressState extends CheckoutState {
  final PaymentEntity payment;

  const CheckoutOnlinePaymentInProgressState({required this.payment});

  @override
  List<Object?> get props => [payment];
}

class CheckoutCashPaymentConfirmationState extends CheckoutState {
  final PaymentEntity payment;
  final List<CartItemEntity> items;

  const CheckoutCashPaymentConfirmationState({
    required this.payment,
    required this.items,
  });

  @override
  List<Object?> get props => [payment, items];
}

class CheckoutOrderCreatingState extends CheckoutState {
  const CheckoutOrderCreatingState();
}

class CheckoutSuccessState extends CheckoutState {
  // final OrderEntity order;

  const CheckoutSuccessState();

  @override
  List<Object?> get props => [];
}

class CheckoutErrorState extends CheckoutState {
  final String message;
  final Failure? failure;

  const CheckoutErrorState({required this.message, this.failure});

  @override
  List<Object?> get props => [message, failure];
}

class CheckoutPaymentFailedState extends CheckoutState {
  final String message;
  // final PaymentEntity payment;

  const CheckoutPaymentFailedState({
    required this.message,
    // required this.payment,
  });

  @override
  List<Object?> get props => [message];
}
