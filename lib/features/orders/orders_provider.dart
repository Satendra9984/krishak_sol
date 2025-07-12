// create all the providers

// create datasource providers

import 'package:bhoomi_sakti/app/core/providers/core_providers.dart';
import 'package:bhoomi_sakti/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:bhoomi_sakti/features/orders/data/repositories/order_repostiroy_impl.dart';
import 'package:bhoomi_sakti/features/orders/domain/repositories/order_repository.dart';
import 'package:bhoomi_sakti/features/orders/domain/usecases/cancel_order.dart';
import 'package:bhoomi_sakti/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:bhoomi_sakti/features/orders/domain/usecases/get_order_by_id.dart';
import 'package:bhoomi_sakti/features/orders/domain/usecases/get_orders.dart';
import 'package:bhoomi_sakti/features/orders/presentation/providers/order_state.dart';
import 'package:bhoomi_sakti/features/orders/presentation/providers/orders_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderRemoteDataSourceProvider = Provider<OrdersRemoteDataSource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return OrdersRemoteDataSourceImpl(apiClient: dio);
});

// create repository providers

final orderRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepositoryImpl(
    remoteDataSource: ref.watch(orderRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

// create usecase providers
final getOrdersUseCaseProvider = Provider<GetOrders>((ref) {
  return GetOrders(ref.watch(orderRepositoryProvider));
});

final getOrderByIdUseCaseProvider = Provider<GetOrderById>((ref) {
  return GetOrderById(ref.watch(orderRepositoryProvider));
});

final cancelOrderUseCaseProvider = Provider<CancelOrder>((ref) {
  return CancelOrder(ref.watch(orderRepositoryProvider));
});

final createOrderUseCaseProvider = Provider<CreateOrderUseCase>((ref) {
  return CreateOrderUseCase(ref.watch(orderRepositoryProvider));
});

final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((
  ref,
) {
  // These would be injected through your DI container
  // Ensure these providers exist and return the correct UseCase instances
  final getOrders = ref.read(getOrdersUseCaseProvider);
  final getOrderById = ref.read(getOrderByIdUseCaseProvider);
  final cancelOrder = ref.read(cancelOrderUseCaseProvider);
  // final createOrder = ref.read(createOrderUseCaseProvider);
  return OrdersNotifier(getOrders, getOrderById, cancelOrder);
});

// Dummy providers for GetOrders, GetOrderById, CancelOrder for example purposes
// You should have your actual domain layer providers here.

// create notifier providers
