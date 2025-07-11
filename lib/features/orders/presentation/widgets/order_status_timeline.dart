import 'package:flutter/material.dart';
import '../../domain/entities/order.dart';

class OrderStatusTimeline extends StatelessWidget {
  final OrderEntity order;

  const OrderStatusTimeline({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final statuses = _getOrderStatuses();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Status Timeline',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...statuses.asMap().entries.map((entry) {
              final index = entry.key;
              final status = entry.value;
              final isLast = index == statuses.length - 1;

              return _buildTimelineItem(context, status, isLast);
            }).toList(),
          ],
        ),
      ),
    );
  }

  List<OrderStatusItem> _getOrderStatuses() {
    final currentStatus = order.orderStatus.toLowerCase();

    return [
      OrderStatusItem(
        title: 'Order Placed',
        subtitle: 'Order has been placed successfully',
        isCompleted: true,
        time: 'Today, 10:30 AM', // Static for now
      ),
      OrderStatusItem(
        title: 'Confirmed',
        subtitle: 'Order confirmed by agent',
        isCompleted: [
          'confirmed',
          'processing',
          'shipped',
          'delivered',
        ].contains(currentStatus),
        time: currentStatus == 'pending' ? null : 'Today, 11:00 AM',
      ),
      OrderStatusItem(
        title: 'Processing',
        subtitle: 'Order is being processed',
        isCompleted: [
          'processing',
          'shipped',
          'delivered',
        ].contains(currentStatus),
        time:
            ['processing', 'shipped', 'delivered'].contains(currentStatus)
                ? 'Today, 2:00 PM'
                : null,
      ),
      OrderStatusItem(
        title: 'Shipped',
        subtitle: 'Order has been shipped',
        isCompleted: ['shipped', 'delivered'].contains(currentStatus),
        time:
            ['shipped', 'delivered'].contains(currentStatus)
                ? 'Yesterday, 9:00 AM'
                : null,
      ),
      OrderStatusItem(
        title: 'Delivered',
        subtitle: 'Order has been delivered',
        isCompleted: currentStatus == 'delivered',
        time: currentStatus == 'delivered' ? 'Yesterday, 4:30 PM' : null,
      ),
    ];
  }

  Widget _buildTimelineItem(
    BuildContext context,
    OrderStatusItem status,
    bool isLast,
  ) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    status.isCompleted
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300],
              ),
              child:
                  status.isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
            ),
            if (!isLast)
              Container(width: 2, height: 40, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: status.isCompleted ? Colors.black : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                status.subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              if (status.time != null) ...[
                const SizedBox(height: 2),
                Text(
                  status.time!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
              if (!isLast) const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class OrderStatusItem {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final String? time;

  OrderStatusItem({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.time,
  });
}
