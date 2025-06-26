import 'package:bhoomi_sakti/features/cart/cart_providers.dart';
import 'package:bhoomi_sakti/features/cart/domain/entities/cart_item_entity.dart';
import 'package:bhoomi_sakti/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({super.key, required this.item, required this.ref});

  final CartItemEntity item;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              color: Colors.grey[200],
              child: const Icon(Icons.image), // Placeholder for product image
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '₹${item.product.price.toStringAsFixed(2)}',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    ref
                        .read(cartBlocProvider)
                        .add(
                          UpdateItemQuantity(
                            productId: item.product.productId.toString(),
                            newQuantity: item.quantity - 1,
                          ),
                        );
                  },
                ),
                Text('${item.quantity}'),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    ref
                        .read(cartBlocProvider)
                        .add(
                          UpdateItemQuantity(
                            productId: item.product.productId.toString(),
                            newQuantity: item.quantity + 1,
                          ),
                        );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
