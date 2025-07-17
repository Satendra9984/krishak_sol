import 'package:bhoomi_sakti/features/orders/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order.dart';
import '../providers/orders_provider.dart';

class OrderActionsSection extends ConsumerWidget {
  final OrderEntity order;

  const OrderActionsSection({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Actions',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (order.canTrack) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showTrackingDialog(context);
                      },
                      icon: const Icon(Icons.location_on_outlined),
                      label: const Text('Track Order'),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                if (order.canCancel) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showCancelOrderDialog(context, ref);
                      },
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text('Cancel Order'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showReorderDialog(context);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reorder'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showContactSupportDialog(context);
                },
                icon: const Icon(Icons.support_agent),
                label: const Text('Contact Support'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTrackingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Track Order'),
            content: const Text(
              'Order tracking information will be available here.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showCancelOrderDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancel Order'),
            content: const Text('Are you sure you want to cancel this order?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(ordersProvider.notifier).cancelOrder(order.orderId);
                },
                child: const Text('Yes, Cancel'),
              ),
            ],
          ),
    );
  }

  void _showReorderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reorder Items'),
            content: const Text('Add all items from this order to your cart?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Add reorder logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Items added to cart')),
                  );
                },
                child: const Text('Add to Cart'),
              ),
            ],
          ),
    );
  }

  void _showContactSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Contact Support'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Need help with your order?'),
                const SizedBox(height: 16),
                const Text('Agent Details:'),
                Text('Name: ${order.agentName}'),
                Text('Phone: ${order.agentMobileNumber}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Add call functionality here
                },
                child: const Text('Call Agent'),
              ),
            ],
          ),
    );
  }
}
