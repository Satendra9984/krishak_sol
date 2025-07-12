part of 'checkout_bloc.dart';

sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class CheckoutInitialize extends CheckoutEvent {
  final String agentId;

  const CheckoutInitialize({required this.agentId});
}

class CheckoutPaymentMethodSelected extends CheckoutEvent {
  final PaymentMode paymentMode;

  const CheckoutPaymentMethodSelected({required this.paymentMode});

  @override
  List<Object?> get props => [paymentMode];
}

class CheckoutPaymentCreated extends CheckoutEvent {
  final double amount;
  final PaymentMode paymentMode;

  const CheckoutPaymentCreated({
    required this.amount,
    required this.paymentMode,
  });

  @override
  List<Object?> get props => [amount, paymentMode];
}

class CheckoutOnlinePaymentCompleted extends CheckoutEvent {
  final int paymentId;
  final bool isSuccess;

  const CheckoutOnlinePaymentCompleted({
    required this.paymentId,
    required this.isSuccess,
  });

  @override
  List<Object?> get props => [paymentId, isSuccess];
}

class CheckoutCashPaymentConfirmed extends CheckoutEvent {
  final int paymentId;
  final CartEntity cart;

  const CheckoutCashPaymentConfirmed({
    required this.paymentId,
    required this.cart,
  });

  @override
  List<Object?> get props => [paymentId, cart];
}

class CheckoutRetryPayment extends CheckoutEvent {
  const CheckoutRetryPayment();
}

class CheckoutReset extends CheckoutEvent {
  const CheckoutReset();
}
