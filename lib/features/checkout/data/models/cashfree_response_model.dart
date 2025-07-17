import 'package:bhoomi_sakti/features/checkout/domain/entities/payment_entity.dart';

class CashfreeOrderResponseModel extends CashfreeOrderResponse {
  const CashfreeOrderResponseModel({
    required super.orderId,
    required super.orderExpiryTime,
    required super.paymentSessionId,
  });

  factory CashfreeOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return CashfreeOrderResponseModel(
      orderId: json['order_id'] ?? '',
      orderExpiryTime: json['order_expiry_time'] ?? '',
      paymentSessionId: json['payment_session_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'order_expiry_time': orderExpiryTime,
      'payment_session_id': paymentSessionId,
    };
  }
}
