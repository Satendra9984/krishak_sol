import 'package:bhoomi_sakti/features/payment/domain/entities/payment_entity.dart';
import 'package:flutter/material.dart';

class CheckoutBottomBar extends StatelessWidget {
  final double totalAmount;
  final PaymentMode? selectedPaymentMode;
  final VoidCallback onProceedToPayment;
  final bool isEnabled;

  const CheckoutBottomBar({
    Key? key,
    required this.totalAmount,
    required this.selectedPaymentMode,
    required this.onProceedToPayment,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.colorScheme.outline)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '₹${totalAmount.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 160,
              height: 48,
              child: ElevatedButton(
                onPressed: isEnabled ? onProceedToPayment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  disabledBackgroundColor: theme.colorScheme.surfaceVariant,
                  disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _getButtonText(),
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonText() {
    if (selectedPaymentMode == PaymentMode.cash) {
      return 'Confirm Order';
    } else if (selectedPaymentMode == PaymentMode.online) {
      return 'Pay Now';
    }
    return 'Proceed';
  }
}
