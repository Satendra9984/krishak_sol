import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:fpdart/fpdart.dart';

enum CashfreePaymentResult { success, failed, cancelled }

abstract class CashfreeRepository {
  Future<Either<Failure, CashfreePaymentResult>> processPayment({
    required String orderId,
    required String paymentSessionId,
    required double amount,
  });
}
