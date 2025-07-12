// lib/features/checkout/presentation/bloc/checkout_bloc.dart

import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/cart/domain/entities/cart_entity.dart';
import 'package:bhoomi_sakti/features/cart/domain/entities/cart_item_entity.dart';
import 'package:bhoomi_sakti/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:bhoomi_sakti/features/orders/domain/entities/order.dart';
import 'package:bhoomi_sakti/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:bhoomi_sakti/features/payment/domain/entities/payment_entity.dart';
import 'package:bhoomi_sakti/features/payment/domain/utils/payment_calculator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bhoomi_sakti/features/payment/domain/usecases/create_payment_usecase.dart';
import 'package:bhoomi_sakti/features/payment/domain/usecases/update_payment_status_usecase.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CreatePaymentUseCase createPaymentUseCase;
  final CreateOrderUseCase createOrderUseCase;
  final UpdatePaymentStatusUseCase updatePaymentStatusUseCase;
  final GetCartUsecase getCartItemsUseCase;
  final PaymentCalculator paymentCalculator;

  CheckoutBloc({
    required this.createPaymentUseCase,
    required this.createOrderUseCase,
    required this.updatePaymentStatusUseCase,
    required this.getCartItemsUseCase,
    required this.paymentCalculator,
  }) : super(const CheckoutInitialState()) {
    on<CheckoutInitialize>(_onInitialize);
    on<CheckoutPaymentMethodSelected>(_onPaymentMethodSelected);
    on<CheckoutPaymentCreated>(_onPaymentCreated);
    on<CheckoutOnlinePaymentCompleted>(_onOnlinePaymentCompleted);
    on<CheckoutCashPaymentConfirmed>(_onCashPaymentConfirmed);
    on<CheckoutRetryPayment>(_onRetryPayment);
    on<CheckoutReset>(_onReset);
  }

  String? agentId;
  CartEntity? cart;

  Future<void> _onInitialize(
    CheckoutInitialize event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutLoadingState());

    try {
      final cartResult = await getCartItemsUseCase.call(NoParams());

      await cartResult.fold(
        (failure) async {
          emit(
            CheckoutErrorState(
              message: _mapFailureToMessage(failure),
              failure: failure,
            ),
          );
        },
        (cartItems) async {
          final totalAmount = paymentCalculator.calculateTotal(cartItems.items);

          agentId = event.agentId;
          cart = cartItems;

          emit(
            CheckoutLoadedState(
              cartItems: cartItems.items,
              totalAmount: totalAmount,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        CheckoutErrorState(
          message: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onPaymentMethodSelected(
    CheckoutPaymentMethodSelected event,
    Emitter<CheckoutState> emit,
  ) async {
    if (state is CheckoutLoadedState) {
      final currentState = state as CheckoutLoadedState;
      emit(currentState.copyWith(selectedPaymentMode: event.paymentMode));
    }
  }

  Future<void> _onPaymentCreated(
    CheckoutPaymentCreated event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutPaymentCreatingState());

    final result = await createPaymentUseCase(
      CreatePaymentParams(amount: event.amount, paymentMode: event.paymentMode),
    );

    result.fold(
      (failure) {
        emit(
          CheckoutErrorState(
            message: _mapFailureToMessage(failure),
            failure: failure,
          ),
        );
      },
      (payment) {
        emit(CheckoutPaymentCreatedState(payment: payment));
      },
    );
  }

  Future<void> _onOnlinePaymentCompleted(
    CheckoutOnlinePaymentCompleted event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutOrderCreatingState());

    if (event.isSuccess) {
      // Update payment status to completed
      final updateResult = await updatePaymentStatusUseCase(
        UpdatePaymentStatusParams(
          paymentId: event.paymentId,
          status: PaymentStatus.completed,
        ),
      );

      updateResult.fold(
        (failure) {
          emit(
            CheckoutErrorState(
              message: _mapFailureToMessage(failure),
              failure: failure,
            ),
          );
        },
        (_) {
          // Payment status updated successfully
          // Navigate to orders screen (handled by UI)
          emit(const CheckoutSuccessState());
        },
      );
    } else {
      // Payment failed, update status accordingly
      final updateResult = await updatePaymentStatusUseCase(
        UpdatePaymentStatusParams(
          paymentId: event.paymentId,
          status: PaymentStatus.failed,
        ),
      );

      updateResult.fold(
        (failure) {
          emit(
            CheckoutErrorState(
              message: _mapFailureToMessage(failure),
              failure: failure,
            ),
          );
        },
        (_) {
          emit(
            const CheckoutPaymentFailedState(
              message: 'Payment was not completed. Please try again.',
            ),
          );
        },
      );
    }
  }

  Future<void> _onCashPaymentConfirmed(
    CheckoutCashPaymentConfirmed event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutOrderCreatingState());

    final result = await createOrderUseCase(
      CreateOrderParams(
        cart: cart!,
        paymentId: event.paymentId,
        agentId: int.parse(agentId!),
      ),
    );

    result.fold(
      (failure) {
        emit(
          CheckoutErrorState(
            message: _mapFailureToMessage(failure),
            failure: failure,
          ),
        );
      },
      (order) {
        emit(const CheckoutSuccessState());
      },
    );
  }

  Future<void> _onRetryPayment(
    CheckoutRetryPayment event,
    Emitter<CheckoutState> emit,
  ) async {
    add(CheckoutInitialize(agentId: agentId!));
  }

  Future<void> _onReset(
    CheckoutReset event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutInitialState());
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Server error occurred. Please try again.';
      case NetworkFailure _:
        return 'Network error. Please check your connection.';
      case CacheFailure _:
        return 'Cache error occurred.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}
