import '../../domain/entities/order.dart';

/// Represents the various states of the orders feature.
sealed class OrdersState {
  const OrdersState();
}

/// The initial state of the orders feature, before any operations.
class InitialOrdersState extends OrdersState {
  const InitialOrdersState();
}

/// Indicates that orders data is currently being loaded.
class LoadingOrdersState extends OrdersState {
  const LoadingOrdersState();
}

/// Represents the state where orders data has been successfully loaded.
class LoadedOrdersState extends OrdersState {
  final List<OrderEntity> orders;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const LoadedOrdersState({
    required this.orders,
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  /// Creates a new [LoadedOrdersState] with updated values.
  LoadedOrdersState copyWith({
    List<OrderEntity>? orders,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return LoadedOrdersState(
      orders: orders ?? this.orders,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Represents the state where a single order's details have been loaded.
class OrderDetailLoadedState extends OrdersState {
  final OrderEntity order;

  const OrderDetailLoadedState(this.order);
}

/// Represents an error state in the orders feature.
class ErrorOrdersState extends OrdersState {
  final String message;

  const ErrorOrdersState(this.message);
}

/// Extension methods to easily check the type and access data of [OrdersState].
extension OrdersStateX on OrdersState {
  bool get isLoading => this is LoadingOrdersState;
  bool get isLoaded => this is LoadedOrdersState;
  bool get isError => this is ErrorOrdersState;
  bool get isInitial => this is InitialOrdersState;
  bool get isOrderDetailLoaded => this is OrderDetailLoadedState;

  List<OrderEntity> get orders {
    if (this is LoadedOrdersState) {
      return (this as LoadedOrdersState).orders;
    }
    return [];
  }

  int get currentPage {
    if (this is LoadedOrdersState) {
      return (this as LoadedOrdersState).currentPage;
    }
    return 1;
  }

  bool get hasMore {
    if (this is LoadedOrdersState) {
      return (this as LoadedOrdersState).hasMore;
    }
    return false;
  }

  bool get isLoadingMore {
    if (this is LoadedOrdersState) {
      return (this as LoadedOrdersState).isLoadingMore;
    }
    return false;
  }

  String get errorMessage {
    if (this is ErrorOrdersState) {
      return (this as ErrorOrdersState).message;
    }
    return '';
  }

  OrderEntity? get orderDetail {
    if (this is OrderDetailLoadedState) {
      return (this as OrderDetailLoadedState).order;
    }
    return null;
  }
}
