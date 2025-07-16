import 'package:bhoomi_sakti/features/cart/domain/entities/cart_item_entity.dart';
import 'package:flutter/material.dart';

class PaymentSummary extends StatelessWidget {
  final List<CartItemEntity> cartItems;
  final double totalAmount;

  const PaymentSummary({
    Key? key,
    required this.cartItems,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final subtotal = cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
    final tax = subtotal * 0.18; // 18% GST
    final deliveryFee = 50.0; // Fixed delivery fee

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', subtotal, theme),
          const SizedBox(height: 8),
          _buildSummaryRow('Tax (18%)', tax, theme),
          const SizedBox(height: 8),
          _buildSummaryRow('Delivery Fee', deliveryFee, theme),
          const SizedBox(height: 12),
          Divider(color: theme.colorScheme.outline),
          const SizedBox(height: 12),
          _buildSummaryRow('Total', totalAmount, theme, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double amount,
    ThemeData theme, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              isTotal
                  ? theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  )
                  : theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style:
              isTotal
                  ? theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  )
                  : theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
        ),
      ],
    );
  }
}
