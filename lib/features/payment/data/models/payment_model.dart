import 'package:bhoomi_sakti/features/payment/data/models/cashfree_response_model.dart';
import 'package:bhoomi_sakti/features/payment/domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.paymentId,
    required super.amount,
    required super.paymentMode,
    required super.status,
    super.cashfreeOrderResponse,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      paymentId: json['paymentId'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      paymentMode: _paymentModeFromString(json['paymentMode'] ?? ''),
      status: _paymentStatusFromString(json['status'] ?? 'PENDING'),
      cashfreeOrderResponse:
          json['cashfreeOrderResponse'] != null
              ? CashfreeOrderResponseModel.fromJson(
                json['cashfreeOrderResponse'],
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'amount': amount,
      'paymentMode': paymentMode == PaymentMode.online ? 'ONLINE' : 'CASH',
      'status': status == PaymentStatus.completed ? 'COMPLETED' : 'PENDING',
      'cashfreeOrderResponse':
          cashfreeOrderResponse != null
              ? (cashfreeOrderResponse as CashfreeOrderResponseModel).toJson()
              : null,
    };
  }

  static PaymentMode _paymentModeFromString(String mode) {
    switch (mode.toUpperCase()) {
      case 'ONLINE':
        return PaymentMode.online;
      case 'CASH':
        return PaymentMode.cash;
      default:
        return PaymentMode.cash;
    }
  }

  static PaymentStatus _paymentStatusFromString(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return PaymentStatus.completed;
      case 'PENDING':
        return PaymentStatus.pending;
      default:
        return PaymentStatus.pending;
    }
  }
}
