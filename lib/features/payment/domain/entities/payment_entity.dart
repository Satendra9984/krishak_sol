import 'package:bhoomi_sakti/features/payment/domain/entities/payment_mode.dart';
import 'package:bhoomi_sakti/features/payment/domain/entities/payment_status.dart';
import 'package:equatable/equatable.dart';

// Usage Examples:

class PaymentEntity extends Equatable {
  final int paymentId;
  final double amount;
  final PaymentMode paymentMode;
  final PaymentStatus status;
  final CashfreeOrderResponse? cashfreeOrderResponse;

  const PaymentEntity({
    required this.paymentId,
    required this.amount,
    required this.paymentMode,
    required this.status,
    this.cashfreeOrderResponse,
  });

  @override
  List<Object?> get props => [
    paymentId,
    amount,
    paymentMode,
    status,
    cashfreeOrderResponse,
  ];
}

class CashfreeOrderResponse extends Equatable {
  final String orderId;
  final String orderExpiryTime;
  final String paymentSessionId;

  const CashfreeOrderResponse({
    required this.orderId,
    required this.orderExpiryTime,
    required this.paymentSessionId,
  });

  @override
  List<Object> get props => [orderId, orderExpiryTime, paymentSessionId];
}
