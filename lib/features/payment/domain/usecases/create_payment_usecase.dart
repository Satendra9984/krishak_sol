import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/payment/domain/entities/payment_entity.dart';
import 'package:bhoomi_sakti/features/payment/domain/repository/payment_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:bhoomi_sakti/features/payment/domain/entities/payment_mode.dart';

class CreatePaymentUseCase
    extends FutureUseCase<PaymentEntity, CreatePaymentParams> {
  final PaymentRepository repository;

  CreatePaymentUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentEntity>> call(
    CreatePaymentParams params,
  ) async {
    return await repository.createPayment(
      amount: params.amount,
      paymentMode: params.paymentMode,
    );
  }
}

class CreatePaymentParams extends Equatable {
  final double amount;
  final PaymentMode paymentMode;

  const CreatePaymentParams({required this.amount, required this.paymentMode});

  @override
  List<Object> get props => [amount, paymentMode];
}
