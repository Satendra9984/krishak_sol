import 'package:bhoomi_sakti/app/core/providers/core_providers.dart';
import 'package:bhoomi_sakti/features/cart/cart_providers.dart';
import 'package:bhoomi_sakti/features/cart/domain/entities/cart_item_entity.dart';
import 'package:bhoomi_sakti/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({super.key, required this.item, required this.ref});

  final CartItemEntity item;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 96,
            height: 80,
            color: Colors.grey[200],
            child: Consumer(
              builder: (context, ref, _) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    item.product.imageUrl!,
                    height: 80,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: SizedBox(
                          height: 200,
                          child: const Icon(Icons.error, color: Colors.red),
                        ),
                      );
                    },
                    headers: {
                      'Authorization':
                          'Bearer ${ref.read(tokenStorageServiceProvider).accessToken}',
                    },
                  ),
                );
              },
            ), // Placeholder for product image
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.product.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    // delete option
                    GestureDetector(
                      child: Icon(Icons.delete, color: Colors.red.shade900),
                      onTap: () {
                        ref
                            .read(cartBlocProvider)
                            .add(
                              RemoveItemFromCart(
                                item.product.productId.toString(),
                              ),
                            );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '₹',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: item.product.price.toStringAsFixed(2),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: (item.product.price * 1.25).toStringAsFixed(
                              0,
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 1,
                            ),
                          ),
                          TextSpan(
                            text: ' 25% off',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(cartBlocProvider)
                            .add(
                              UpdateItemQuantity(
                                productId: item.product.productId.toString(),
                                newQuantity: item.quantity - 1,
                              ),
                            );
                      },
                      child: Container(
                        padding: EdgeInsets.all(2),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                          // border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${item.quantity} pc',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(cartBlocProvider)
                            .add(
                              UpdateItemQuantity(
                                productId: item.product.productId.toString(),
                                newQuantity: item.quantity + 1,
                              ),
                            );
                      },
                      child: Container(
                        padding: EdgeInsets.all(2),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                          // border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Icon(
                          Icons.add,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
