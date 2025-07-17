import '../../domain/entities/order.dart';
import 'order_item_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.orderId,
    required super.totalAmount,
    required super.paymentStatus,
    required super.orderStatus,
    required super.userId,
    required super.userName,
    required super.userMobileNumber,
    required super.agentId,
    required super.agentName,
    required super.agentMobileNumber,
    required super.items,
    super.createdAt,
    super.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'] as int,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentStatus: json['paymentStatus'] as String,
      orderStatus: json['orderStatus'] as String,
      userId: json['userId'] as int,
      userName: json['userName'] as String,
      userMobileNumber: json['userMobileNumber'] as String,
      agentId: json['agentId'] as int,
      agentName: json['agentName'] as String,
      agentMobileNumber: json['agentMobileNumber'] as String,
      items:
          (json['items'] as List<dynamic>)
              .map(
                (item) => OrderItemModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'userId': userId,
      'userName': userName,
      'userMobileNumber': userMobileNumber,
      'agentId': agentId,
      'agentName': agentName,
      'agentMobileNumber': agentMobileNumber,
      'items': items.map((item) => (item as OrderItemModel).toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
