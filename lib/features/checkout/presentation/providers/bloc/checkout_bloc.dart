// lib/features/checkout/presentation/bloc/checkout_bloc.dart

import 'package:bhoomi_sakti/app/core/error/app_failures.dart';
import 'package:bhoomi_sakti/app/core/usecases/usecase.dart';
import 'package:bhoomi_sakti/features/cart/domain/entities/cart_entity.dart';
import 'package:bhoomi_sakti/features/cart/domain/entities/cart_item_entity.dart';
import 'package:bhoomi_sakti/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:bhoomi_sakti/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:bhoomi_sakti/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:bhoomi_sakti/features/checkout/domain/entities/payment_entity.dart';
import 'package:bhoomi_sakti/features/checkout/domain/utils/payment_calculator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bhoomi_sakti/features/checkout/domain/usecases/create_payment_usecase.dart';
import 'package:bhoomi_sakti/features/checkout/domain/usecases/update_payment_status_usecase.dart';

import 'package:bhoomi_sakti/features/checkout/domain/entities/payment_mode.dart';
import 'package:bhoomi_sakti/features/checkout/domain/entities/payment_status.dart';
part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CreatePaymentUseCase createPaymentUseCase;
  final CreateOrderUseCase createOrderUseCase;
  final UpdatePaymentStatusUseCase updatePaymentStatusUseCase;
  final GetCartUsecase getCartItemsUseCase;
  final ClearCartUsecase clearCartUseCase;
  final PaymentCalculator paymentCalculator;

  CheckoutBloc({
    required this.createPaymentUseCase,
    required this.createOrderUseCase,
    required this.updatePaymentStatusUseCase,
    required this.getCartItemsUseCase,
    required this.clearCartUseCase,
    required this.paymentCalculator,
  }) : super(const CheckoutInitialState()) {
    on<CheckoutInitialize>(_onInitialize);
    on<CheckoutPaymentMethodSelected>(_onPaymentMethodSelected);
    on<CheckoutPaymentCreated>(_onPaymentCreated);
    on<CheckoutOnlinePaymentCompleted>(_onOnlinePaymentCompleted);
    on<CheckoutOrderConfirmed>(_onConfirmOrder);
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
        cart = cartItems;
        agentId = event.agentId;
        emit(
          CheckoutLoadedState(
            cartItems: cartItems.items,
            totalAmount: totalAmount,
            selectedAgentId: int.parse(event.agentId),
            selectedPaymentMode: null,
          ),
        );
      },
    );
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
            message: 'onPaymentCreated' + _mapFailureToMessage(failure),
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
          paymentId: event.payment.paymentId,
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
          add(CheckoutOrderConfirmed(payment: event.payment));
          emit(const CheckoutSuccessState());
        },
      );
    } else {
      // Payment failed, update status accordingly
      final updateResult = await updatePaymentStatusUseCase(
        UpdatePaymentStatusParams(
          paymentId: event.payment.paymentId,
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

  Future<void> _onConfirmOrder(
    CheckoutOrderConfirmed event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutOrderCreatingState());

    final result = await createOrderUseCase(
      CreateOrderParams(
        cart: cart!,
        paymentId: event.payment.paymentId,
        agentId: int.parse(agentId!),
      ),
    );

    result.fold(
      (failure) {
        emit(
          CheckoutErrorState(
            message: 'onConfirmOrder' + _mapFailureToMessage(failure),
            failure: failure,
          ),
        );
      },
      (order) {
        emit(const CheckoutSuccessState());
        clearCartUseCase.call(NoParams());
      },
    );
  }

  Future<void> _onRetryPayment(
    CheckoutRetryPayment event,
    Emitter<CheckoutState> emit,
  ) async {
    add(CheckoutInitialize(agentId: event.agentId));
  }

  Future<void> _onReset(
    CheckoutReset event,
    Emitter<CheckoutState> emit,
  ) async {
    cart = null;
    agentId = null;
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
