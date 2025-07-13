import 'package:bhoomi_sakti/app/core/providers/core_providers.dart';
import 'package:bhoomi_sakti/features/cart/cart_providers.dart';
import 'package:bhoomi_sakti/features/orders/orders_provider.dart';
import 'package:bhoomi_sakti/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:bhoomi_sakti/features/payment/data/repository/payment_repository_impl.dart';
import 'package:bhoomi_sakti/features/payment/domain/repository/payment_repository.dart';
import 'package:bhoomi_sakti/features/payment/domain/usecases/create_payment_usecase.dart';
import 'package:bhoomi_sakti/features/payment/domain/usecases/update_payment_status_usecase.dart';
import 'package:bhoomi_sakti/features/payment/domain/utils/payment_calculator.dart';
import 'package:bhoomi_sakti/features/payment/presentation/providers/bloc/checkout_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(apiClientProvider);
  return PaymentRemoteDataSourceImpl(apiClient: dio);
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl(
    remoteDataSource: ref.read(paymentRemoteDataSourceProvider),
  );
});

final createPaymentUsecaseProvider = Provider<CreatePaymentUseCase>((ref) {
  return CreatePaymentUseCase(ref.watch(paymentRepositoryProvider));
});

final updatePaymentStatusUsecaseProvider = Provider<UpdatePaymentStatusUseCase>(
  (ref) {
    return UpdatePaymentStatusUseCase(ref.watch(paymentRepositoryProvider));
  },
);

// final getPaymentByIdUsecaseProvider = Provider<GetPaymentByIdUseCase>((ref) {
//   return GetPaymentByIdUseCase(ref.watch(paymentRepositoryProvider));
// });

final paymentCalculatorProvider = Provider<PaymentCalculator>((ref) {
  return PaymentCalculator();
});

final checkoutBlocProvider = Provider<CheckoutBloc>((ref) {
  final bloc = CheckoutBloc(
    createPaymentUseCase: ref.watch(createPaymentUsecaseProvider),
    updatePaymentStatusUseCase: ref.watch(updatePaymentStatusUsecaseProvider),
    paymentCalculator: ref.watch(paymentCalculatorProvider),
    createOrderUseCase: ref.watch(createOrderUseCaseProvider),
    getCartItemsUseCase: ref.watch(getCartUsecaseProvider),
    clearCartUseCase: ref.watch(clearCartUsecaseProvider),
  );

  ref.onDispose(() {
    bloc.close();
  });

  return bloc;
});
