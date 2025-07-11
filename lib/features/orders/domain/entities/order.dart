import 'package:equatable/equatable.dart';
import 'order_item.dart';

class Order extends Equatable {
  final int orderId;
  final double totalAmount;
  final String paymentStatus;
  final String orderStatus;
  final int userId;
  final String userName;
  final String userMobileNumber;
  final int agentId;
  final String agentName;
  final String agentMobileNumber;
  final List<OrderItem> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Order({
    required this.orderId,
    required this.totalAmount,
    required this.paymentStatus,
    required this.orderStatus,
    required this.userId,
    required this.userName,
    required this.userMobileNumber,
    required this.agentId,
    required this.agentName,
    required this.agentMobileNumber,
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    orderId,
    totalAmount,
    paymentStatus,
    orderStatus,
    userId,
    userName,
    userMobileNumber,
    agentId,
    agentName,
    agentMobileNumber,
    items,
    createdAt,
    updatedAt,
  ];

  bool get isDelivered => orderStatus.toLowerCase() == 'delivered';
  bool get isShipped => orderStatus.toLowerCase() == 'shipped';
  bool get isPending => orderStatus.toLowerCase() == 'pending';
  bool get isCancelled => orderStatus.toLowerCase() == 'cancelled';

  bool get canCancel => isPending || orderStatus.toLowerCase() == 'confirmed';
  bool get canTrack => isShipped || orderStatus.toLowerCase() == 'processing';
}
