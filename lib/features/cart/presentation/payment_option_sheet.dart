import 'package:bhoomi_sakti/features/payment/domain/entities/payment_entity.dart';
import 'package:flutter/material.dart';

class PaymentOptionSheet extends StatefulWidget {
  const PaymentOptionSheet({super.key});

  @override
  State<PaymentOptionSheet> createState() => _PaymentOptionSheetState();
}

class _PaymentOptionSheetState extends State<PaymentOptionSheet> {
  PaymentMode _paymentMode = PaymentMode.online;

  void _handlePaymentMode(PaymentMode mode) {
    setState(() {
      _paymentMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // choose payment method
          const Text(
            'Choose Payment Method',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Online Payment'),
            trailing: Radio(
              value: PaymentMode.online,
              groupValue: _paymentMode,
              onChanged: (value) {
                _handlePaymentMode(value!);
              },
            ),
            onTap: () {
              _handlePaymentMode(PaymentMode.online);
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text('Cash on Delivery'),
            trailing: Radio(
              value: PaymentMode.cash,
              groupValue: _paymentMode,
              onChanged: (value) {
                _handlePaymentMode(value!);
              },
            ),
            onTap: () {
              _handlePaymentMode(PaymentMode.cash);
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Handle payment
              },
              child: const Text('Pay'),
            ),
          ),
        ],
      ),
    );
  }
}
