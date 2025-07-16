import 'package:bhoomi_sakti/app/core/error/app_exceptions.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/features/checkout/data/datasources/payment_remote_datasource.dart';
import 'package:bhoomi_sakti/features/checkout/domain/entities/payment_entity.dart';
import 'package:bhoomi_sakti/features/checkout/domain/entities/payment_mode.dart';
import 'package:bhoomi_sakti/features/checkout/domain/entities/payment_status.dart';
import 'package:bhoomi_sakti/features/checkout/domain/repository/payment_repository.dart';
import 'package:fpdart/fpdart.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaymentEntity>> createPayment({
    required double amount,
    required PaymentMode paymentMode,
  }) async {
    try {
      final result = await remoteDataSource.createPayment(
        amount: amount,
        paymentMode: paymentMode,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NoInternetException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updatePaymentStatus({
    required int paymentId,
    required PaymentStatus status,
  }) async {
    try {
      await remoteDataSource.updatePaymentStatus(
        paymentId: paymentId,
        status: status,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NoInternetException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> getPaymentById({
    required int paymentId,
  }) async {
    try {
      final result = await remoteDataSource.getPaymentById(
        paymentId: paymentId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NoInternetException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }
}
