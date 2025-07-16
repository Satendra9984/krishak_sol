import 'package:bhoomi_sakti/features/checkout/domain/entities/payment_mode.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        // border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        children: [
          _buildPaymentOption(
            paymentMode: PaymentMode.online,
            title: 'Online Payment',
            subtitle: 'Pay using UPI, Cards, Net Banking',
            icon: FontAwesomeIcons.creditCard,
            theme: theme,
          ),
          // Divider(color: theme.colorScheme.outline, height: 1),
          _buildPaymentOption(
            paymentMode: PaymentMode.cash,
            title: 'Cash Payment',
            subtitle: 'Pay with cash on delivery',
            icon: FontAwesomeIcons.moneyBill,
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

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? theme.colorScheme.primary : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        color:
            isSelected
                ? theme.colorScheme.primary.withOpacity(
                  0.1,
                ) // Use withOpacity instead
                : Colors.white,
      ),
      child: ListTile(
        onTap: () => onPaymentModeSelected(paymentMode),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // Remove conflicting color properties
        leading: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            icon,
            color:
                isSelected ? theme.colorScheme.primary : Colors.grey.shade600,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge!.copyWith(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Radio<PaymentMode>(
          value: paymentMode,
          groupValue: selectedPaymentMode,
          onChanged: (PaymentMode? value) {
            if (value != null) {
              onPaymentModeSelected(value);
            }
          },
          activeColor: theme.colorScheme.primary,
          splashRadius: 20,
        ),
      ),
    );
  }
}
