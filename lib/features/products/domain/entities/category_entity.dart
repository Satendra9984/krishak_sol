import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int categoryId;
  final String name;
  final String? description;

  const CategoryEntity({
    required this.categoryId,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [categoryId, name, description];
}
