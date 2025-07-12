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
  final PaymentEntity payment;
  final bool isSuccess;

  const CheckoutOnlinePaymentCompleted({
    required this.payment,
    required this.isSuccess,
  });

  @override
  List<Object?> get props => [payment, isSuccess];
}

class CheckoutOrderConfirmed extends CheckoutEvent {
  final PaymentEntity payment;

  const CheckoutOrderConfirmed({required this.payment});

  @override
  List<Object?> get props => [payment];
}

class CheckoutRetryPayment extends CheckoutEvent {
  final String agentId;

  const CheckoutRetryPayment({required this.agentId});
}

class CheckoutReset extends CheckoutEvent {
  const CheckoutReset();
}
