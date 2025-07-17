import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/checkout/domain/entities/payment_status.dart';
import 'package:bhoomi_sakti/features/checkout/domain/repository/payment_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

class UpdatePaymentStatusUseCase
    extends FutureUseCase<void, UpdatePaymentStatusParams> {
  final PaymentRepository repository;

  UpdatePaymentStatusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdatePaymentStatusParams params) async {
    return await repository.updatePaymentStatus(
      paymentId: params.paymentId,
      status: params.status,
    );
  }
}

class UpdatePaymentStatusParams extends Equatable {
  final int paymentId;
  final PaymentStatus status;

  const UpdatePaymentStatusParams({
    required this.paymentId,
    required this.status,
  });

  @override
  List<Object> get props => [paymentId, status];
}
