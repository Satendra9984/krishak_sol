import 'package:bhoomi_sakti/features/checkout/data/models/cashfree_response_model.dart';
import 'package:bhoomi_sakti/features/checkout/domain/entities/payment_entity.dart';
import 'package:bhoomi_sakti/features/checkout/domain/entities/payment_mode.dart';
import 'package:bhoomi_sakti/features/checkout/domain/entities/payment_status.dart';

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
      'paymentMode': paymentMode.value,
      'status': status.value,
      'cashfreeOrderResponse':
          cashfreeOrderResponse != null
              ? (cashfreeOrderResponse as CashfreeOrderResponseModel).toJson()
              : null,
    };
  }

  static PaymentMode _paymentModeFromString(String mode) {
    switch (mode.toUpperCase()) {
      case 'ONLINE' || 'CASH':
        return PaymentMode.fromString(mode);
      default:
        return PaymentMode.cash;
    }
  }

  static PaymentStatus _paymentStatusFromString(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED' || 'PENDING':
        return PaymentStatus.fromString(status);
      default:
        return PaymentStatus.pending;
    }
  }
}
