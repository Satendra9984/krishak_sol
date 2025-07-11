import 'package:bhoomi_sakti/features/products/data/models/product_model.dart';

import '../../domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.orderItemId,
    required super.quantity,
    required super.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      orderItemId: json['orderItemId'] as int,
      quantity: json['quantity'] as int,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderItemId': orderItemId,
      'quantity': quantity,
      'product': (product as ProductModel).toJson(),
    };
  }
}
