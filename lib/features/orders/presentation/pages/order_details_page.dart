import 'package:bhoomi_sakti/features/orders/orders_provider.dart';
import 'package:bhoomi_sakti/features/orders/presentation/providers/order_state.dart';
import 'package:bhoomi_sakti/features/orders/presentation/widgets/order_action_selection.dart';
import 'package:bhoomi_sakti/features/orders/presentation/widgets/order_details_card.dart';
import 'package:bhoomi_sakti/features/orders/presentation/widgets/order_status_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order.dart';
import '../providers/orders_provider.dart';

class OrderDetailPage extends ConsumerStatefulWidget {
  final int orderId;
  final OrderEntity? order;

  const OrderDetailPage({super.key, required this.orderId, this.order});

  @override
  ConsumerState<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends ConsumerState<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    if (widget.order == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(ordersProvider.notifier).loadOrderById(widget.orderId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.orderId}'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final ordersState = ref.watch(ordersProvider);

          if (ordersState is InitialOrdersState) {
            return const Center(child: Text('Order not found'));
          }

          if (ordersState is LoadingOrdersState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ordersState is ErrorOrdersState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    ordersState.message,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }

          if (ordersState is LoadedOrdersState) {
            return _buildOrderDetail(
              ordersState.orders.firstWhere(
                (order) => order.orderId == widget.orderId,
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  _buildOrderDetail(OrderEntity order) {
    return SingleChildScrollView(
      child: Column(
        children: [
          OrderDetailCard(order: order),
          const SizedBox(height: 16),
          OrderStatusTimeline(order: order),
          const SizedBox(height: 16),
          OrderActionsSection(order: order),
        ],
      ),
    );
  }
}
