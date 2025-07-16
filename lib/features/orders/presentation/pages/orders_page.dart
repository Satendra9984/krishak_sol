import 'package:bhoomi_sakti/features/orders/orders_provider.dart';
import 'package:bhoomi_sakti/features/orders/presentation/providers/order_state.dart';
import 'package:bhoomi_sakti/features/orders/presentation/widgets/ordder_filter_bar.dart';
import 'package:bhoomi_sakti/features/orders/presentation/widgets/order_error_widget.dart';
import 'package:bhoomi_sakti/features/orders/presentation/widgets/order_list.dart';
import 'package:bhoomi_sakti/features/orders/presentation/widgets/order_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/orders_provider.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersProvider.notifier).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Column(
        children: [
          const OrdersFilterBar(),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final ordersState = ref.watch(ordersProvider);

                if (ordersState.isInitial) {
                  return const Center(child: Text('No orders yet'));
                }

                if (ordersState.isLoading) {
                  return const OrdersLoadingWidget();
                }

                if (ordersState.isError) {
                  return OrdersErrorWidget(
                    message: ordersState.errorMessage,
                    onRetry: () {
                      ref.read(ordersProvider.notifier).loadOrders();
                    },
                  );
                }

                if (ordersState.orders.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No orders found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Your orders will appear here',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return OrdersList(
                  orders: ordersState.orders,
                  hasMore: ordersState.hasMore,
                  isLoadingMore: ordersState.isLoadingMore,
                  onLoadMore: () {
                    ref.read(ordersProvider.notifier).loadOrders();
                  },
                  onRefresh: () {
                    return ref
                        .read(ordersProvider.notifier)
                        .loadOrders(refresh: true);
                  },
                );
              },
              // orderDetailLoaded: (order) => const SizedBox.shrink(),
              // error:
              //     (message) => OrdersErrorWidget(
              //       message: message,
              //       onRetry: () {
              //         ref
              //             .read(ordersProvider.notifier)
              //             .loadOrders(refresh: true);
              //       },
              //     ),
              // );
              // },
            ),
          ),
        ],
      ),
    );
  }
}
