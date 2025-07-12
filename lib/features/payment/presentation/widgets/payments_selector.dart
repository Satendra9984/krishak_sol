import 'package:bhoomi_sakti/features/payment/domain/entities/payment_entity.dart';
import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMode? selectedPaymentMode;
  final Function(PaymentMode) onPaymentModeSelected;

  const PaymentMethodSelector({
    Key? key,
    required this.selectedPaymentMode,
    required this.onPaymentModeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        children: [
          _buildPaymentOption(
            paymentMode: PaymentMode.online,
            title: 'Online Payment',
            subtitle: 'Pay using UPI, Cards, Net Banking',
            icon: Icons.payment,
            theme: theme,
          ),
          Divider(color: theme.colorScheme.outline, height: 1),
          _buildPaymentOption(
            paymentMode: PaymentMode.cash,
            title: 'Cash Payment',
            subtitle: 'Pay with cash on delivery',
            icon: Icons.money,
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required PaymentMode paymentMode,
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeData theme,
  }) {
    final isSelected = selectedPaymentMode == paymentMode;

    return InkWell(
      onTap: () => onPaymentModeSelected(paymentMode),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color:
                    isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            Radio<PaymentMode>(
              value: paymentMode,
              groupValue: selectedPaymentMode,
              onChanged: (PaymentMode? value) {
                if (value != null) {
                  onPaymentModeSelected(value);
                }
              },
              activeColor: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
