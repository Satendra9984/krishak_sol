import 'package:bhoomi_sakti/features/orders/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/orders_provider.dart';

class OrdersFilterBar extends ConsumerStatefulWidget {
  const OrdersFilterBar({super.key});

  @override
  ConsumerState<OrdersFilterBar> createState() => _OrdersFilterBarState();
}

class _OrdersFilterBarState extends ConsumerState<OrdersFilterBar> {
  String? selectedStatus;

  final List<String> orderStatuses = [
    'All',
    'Pending',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: orderStatuses.length,
        itemBuilder: (context, index) {
          final status = orderStatuses[index];
          final isSelected =
              selectedStatus == status ||
              (selectedStatus == null && status == 'All');

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(status),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedStatus =
                      selected ? (status == 'All' ? null : status) : null;
                });
                ref
                    .read(ordersProvider.notifier)
                    .filterByStatus(selectedStatus?.toLowerCase());
              },
              backgroundColor: Colors.grey[100],
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              checkmarkColor: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }
}
