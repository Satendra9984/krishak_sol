import 'package:bhoomi_sakti/features/cart/cart_providers.dart';
import 'package:bhoomi_sakti/features/cart/presentation/widget/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/features/cart/presentation/bloc/cart_bloc.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: BlocBuilder<CartBloc, CartState>(
        bloc: ref.watch(cartBlocProvider),
        builder: (context, state) {
          return _buildBody(context, ref, state);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, CartState state) {
    if (state is CartLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is CartLoaded) {
      if (state.cart.items.isEmpty) {
        return const Center(child: Text('Your cart is empty.'));
      }
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: state.cart.items.length,
              itemBuilder: (context, index) {
                final item = state.cart.items[index];
                // This is the key fix: pass the ref down to the widget
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CartItemWidget(item: item, ref: ref),
                );
              },
            ),
          ),
          _buildCartSummary(context, state),
        ],
      );
    }
    if (state is CartError) {
      return Center(child: Text('Error: ${state.message}'));
    }
    return const Center(child: Text('Something went wrong.'));
  }

  Widget _buildCartSummary(BuildContext context, CartLoaded state) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Items:'),
                Text('${state.cart.totalItems}'),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Price:'),
                Text(
                  '₹${state.cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to checkout page
              },
              child: const Text('Proceed to Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
