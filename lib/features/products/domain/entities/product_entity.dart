import 'package:equatable/equatable.dart';
import 'category_entity.dart';

class ProductEntity extends Equatable {
  final int productId;
  final String name;
  final double price;
  final int stock;
  final String? description;
  final String? manufacturer;
  final String? imageUrl;
  final CategoryEntity category;

  const ProductEntity({
    required this.productId,
    required this.name,
    required this.price,
    required this.stock,
    this.description,
    this.manufacturer,
    this.imageUrl,
    required this.category,
  });

  @override
  List<Object?> get props => [
        productId,
        name,
        price,
        stock,
        description,
        manufacturer,
        imageUrl,
        category,
      ];
}
