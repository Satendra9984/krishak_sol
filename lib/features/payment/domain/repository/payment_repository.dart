import 'package:fpdart/fpdart.dart';
import '../entities/payment_entity.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';

abstract class PaymentRepository {
  Future<Either<Failure, PaymentEntity>> createPayment({
    required double amount,
    required PaymentMode paymentMode,
  });

  Future<Either<Failure, void>> updatePaymentStatus({
    required int paymentId,
    required PaymentStatus status,
  });

  Future<Either<Failure, PaymentEntity>> getPaymentById({
    required int paymentId,
  });
}
