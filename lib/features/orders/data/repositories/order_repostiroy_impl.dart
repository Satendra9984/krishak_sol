import 'package:bhoomi_sakti/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:bhoomi_sakti/features/orders/domain/entities/order.dart';
import 'package:bhoomi_sakti/features/orders/domain/repositories/order_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../app/core/error/app_failures.dart';
import '../../../../app/core/error/app_exceptions.dart';
import '../../../../app/core/network/network_info.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders({
    int page = 1,
    int limit = 10,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final orders = await remoteDataSource.getOrders(
          page: page,
          limit: limit,
          status: status,
          fromDate: fromDate,
          toDate: toDate,
        );
        return Right(orders);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(int orderId) async {
    if (await networkInfo.isConnected) {
      try {
        final order = await remoteDataSource.getOrderById(orderId);
        return Right(order);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> cancelOrder(int orderId) async {
    if (await networkInfo.isConnected) {
      try {
        final order = await remoteDataSource.cancelOrder(orderId);
        return Right(order);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> reorderItems(int orderId) async {
    // This would typically add items to cart and redirect to checkout
    // For now, returning empty list as placeholder
    return const Right([]);
  }
}
