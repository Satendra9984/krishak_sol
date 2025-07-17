import 'package:bhoomi_sakti/features/products/data/models/category_model.dart';
import 'package:bhoomi_sakti/features/products/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.productId,
    required super.name,
    required super.price,
    required super.stock,
    super.description,
    super.manufacturer,
    super.imageUrl,
    required super.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
      description: json['description'],
      manufacturer: json['manufacturer'],
      imageUrl: json['imageUrl'],
      category: CategoryModel.fromJson(json['category']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'stock': stock,
      'description': description,
      'manufacturer': manufacturer,
      'imageUrl': imageUrl,
      'category': (category as CategoryModel).toJson(),
    };
  }
}
