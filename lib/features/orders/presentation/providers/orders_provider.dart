import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/get_orders.dart';
import '../../domain/usecases/get_order_by_id.dart';
import '../../domain/usecases/cancel_order.dart';
// Import your simplified state file (assuming it's named 'order_state.dart' as per your original import)
import 'order_state.dart'; // Make sure this path is correct

class OrdersNotifier extends StateNotifier<OrdersState> {
  final GetOrders _getOrders;
  final GetOrderById _getOrderById;
  final CancelOrder _cancelOrder;

  OrdersNotifier(this._getOrders, this._getOrderById, this._cancelOrder)
    : super(const InitialOrdersState()); // Changed from OrdersState.initial()

  Future<void> loadOrders({
    bool refresh = false,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    // Check if the current state is LoadedOrdersState to access its properties
    final currentLoadedState =
        state is LoadedOrdersState ? (state as LoadedOrdersState) : null;

    if (refresh) {
      state = const LoadingOrdersState(); // Changed from OrdersState.loading()
    } else if (state.orders.isEmpty) {
      // Using the extension getter
      state = const LoadingOrdersState(); // Changed from OrdersState.loading()
    } else if (currentLoadedState != null) {
      // Use copyWith for LoadedOrdersState
      state = currentLoadedState.copyWith(isLoadingMore: true);
    } else {
      // Handle cases where state is not Loaded but not initial/loading either,
      // e.g., if it's an error state and we want to load.
      state = const LoadingOrdersState();
    }

    final params = GetOrdersParams(
      page: refresh ? 1 : state.currentPage, // Using the extension getter
      status: status,
      fromDate: fromDate,
      toDate: toDate,
      // Assuming GetOrdersParams has a 'limit' field; if not, you might need to add it or pass it differently.
      limit: 10, // Example limit, adjust as per your API/pagination logic
    );

    final result = await _getOrders(params);

    result.fold(
      (failure) =>
          state = ErrorOrdersState(
            failure.message,
          ), // Changed from OrdersState.error()
      (orders) {
        final List<OrderEntity> updatedOrders;
        if (refresh || currentLoadedState == null) {
          updatedOrders = orders;
        } else {
          updatedOrders = [...currentLoadedState.orders, ...orders];
        }

        state = LoadedOrdersState(
          // Changed from OrdersState.loaded()
          orders: updatedOrders,
          currentPage: params.page + 1,
          hasMore:
              orders.length >=
              params
                  .limit, // Ensure this logic matches your backend's pagination
          isLoadingMore: false, // Reset loadingMore state after loading
        );
      },
    );
  }

  Future<void> loadOrderById(int orderId) async {
    state = const LoadingOrdersState(); // Changed from OrdersState.loading()

    final result = await _getOrderById(orderId);

    result.fold(
      (failure) =>
          state = ErrorOrdersState(
            failure.message,
          ), // Changed from OrdersState.error()
      (order) =>
          state = OrderDetailLoadedState(
            order,
          ), // Changed from OrdersState.orderDetailLoaded()
    );
  }

  Future<void> cancelOrder(int orderId) async {
    // Ideally, you might want to show a loading state specifically for the cancellation
    // or update the UI optimistically. For now, we'll directly update after the call.

    final result = await _cancelOrder(orderId);

    result.fold(
      (failure) =>
          state = ErrorOrdersState(
            failure.message,
          ), // Changed from OrdersState.error()
      (cancelledOrder) {
        // We need to ensure the current state is LoadedOrdersState to update orders
        if (state is LoadedOrdersState) {
          final currentLoadedState = state as LoadedOrdersState;
          final updatedOrders =
              currentLoadedState.orders.map((order) {
                return order.orderId == orderId ? cancelledOrder : order;
              }).toList();

          state = currentLoadedState.copyWith(
            orders: updatedOrders,
          ); // Use copyWith
        } else {
          // If we are not in a loaded state, simply re-fetch or handle as appropriate.
          // For simplicity, we might just re-load all orders.
          loadOrders(refresh: true);
        }
      },
    );
  }

  void clearError() {
    if (state.isError) {
      // Using the extension getter
      state = const InitialOrdersState(); // Changed from OrdersState.initial()
    }
  }

  void filterByStatus(String? status) {
    loadOrders(refresh: true, status: status);
  }

  void filterByDateRange(DateTime? fromDate, DateTime? toDate) {
    loadOrders(refresh: true, fromDate: fromDate, toDate: toDate);
  }
}

// Provider
