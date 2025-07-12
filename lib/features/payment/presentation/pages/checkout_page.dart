// lib/features/checkout/presentation/screens/checkout_screen.dart

import 'package:bhoomi_sakti/app/config/theme/app_colors.dart';
import 'package:bhoomi_sakti/features/payment/domain/entities/payment_entity.dart';
import 'package:bhoomi_sakti/features/payment/presentation/providers/bloc/checkout_bloc.dart';
import 'package:bhoomi_sakti/features/payment/presentation/widgets/checkout_app.dart';
import 'package:bhoomi_sakti/features/payment/presentation/widgets/checkout_bottom_bar.dart';
import 'package:bhoomi_sakti/features/payment/presentation/widgets/checkout_item_list.dart';
import 'package:bhoomi_sakti/features/payment/presentation/widgets/payment_summary.dart';
import 'package:bhoomi_sakti/features/payment/presentation/widgets/payments_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key, required this.agentId}) : super(key: key);

  final String agentId;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CheckoutBloc>().add(
      CheckoutInitialize(agentId: widget.agentId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CheckoutAppBar(),
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          return Stack(
            children: [
              _buildContent(state, theme),
              if (_isLoading(state)) const CircularProgressIndicator(),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          if (state is CheckoutLoadedState) {
            return CheckoutBottomBar(
              totalAmount: state.totalAmount,
              selectedPaymentMode: state.selectedPaymentMode,
              onProceedToPayment: () => _handleProceedToPayment(state),
              isEnabled: _canProceedToPayment(state),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(CheckoutState state, ThemeData theme) {
    switch (state.runtimeType) {
      case CheckoutInitialState:
      case CheckoutLoadingState:
        return const Center(child: CircularProgressIndicator());

      case CheckoutLoadedState:
        return _buildCheckoutContent(state as CheckoutLoadedState, theme);

      case CheckoutErrorState:
        return _buildErrorContent(state as CheckoutErrorState, theme);

      case CheckoutPaymentFailedState:
        return _buildPaymentFailedContent(
          state as CheckoutPaymentFailedState,
          theme,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCheckoutContent(CheckoutLoadedState state, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cart Items Section
          _buildSectionTitle('Your Items', theme),
          const SizedBox(height: 12),
          CartItemsList(items: state.cartItems),

          const SizedBox(height: 24),

          // Payment Method Section
          _buildSectionTitle('Payment Method', theme),
          const SizedBox(height: 12),
          PaymentMethodSelector(
            selectedPaymentMode: state.selectedPaymentMode,
            onPaymentModeSelected: (paymentMode) {
              context.read<CheckoutBloc>().add(
                CheckoutPaymentMethodSelected(paymentMode: paymentMode),
              );
            },
          ),

          const SizedBox(height: 24),

          // Agent Selection Section
          _buildSectionTitle('Select Agent', theme),
          const SizedBox(height: 24),

          // Payment Summary Section
          _buildSectionTitle('Payment Summary', theme),
          const SizedBox(height: 12),
          PaymentSummary(
            cartItems: state.cartItems,
            totalAmount: state.totalAmount,
          ),

          const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium!.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildErrorContent(CheckoutErrorState state, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: theme.textTheme.titleMedium!.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.message,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<CheckoutBloc>().add(const CheckoutRetryPayment());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentFailedContent(
    CheckoutPaymentFailedState state,
    ThemeData theme,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.payment_outlined, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            'Payment Failed',
            style: theme.textTheme.titleMedium!.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.message,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<CheckoutBloc>().add(const CheckoutRetryPayment());
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _handleStateChanges(
    BuildContext context,
    CheckoutState state,
    ThemeData theme,
  ) {
    switch (state.runtimeType) {
      case CheckoutPaymentCreatedState:
        final paymentCreated = state as CheckoutPaymentCreatedState;
        _handlePaymentCreated(paymentCreated, theme);
        break;

      case CheckoutCashPaymentConfirmationState:
        final cashPayment = state as CheckoutCashPaymentConfirmationState;
        _showCashPaymentConfirmation(cashPayment, theme);
        break;

      case CheckoutSuccessState:
        final success = state as CheckoutSuccessState;
        _handleCheckoutSuccess(success);
        break;

      case CheckoutErrorState:
        final error = state as CheckoutErrorState;
        _showErrorDialog(error.message);
        break;
    }
  }

  void _handlePaymentCreated(CheckoutPaymentCreated state, ThemeData theme) {
    if (state.payment.paymentMode == PaymentMode.online) {
      _initiateOnlinePayment(state.payment);
    } else {
      // For cash payments, show confirmation screen
      // This will be handled by the bloc state change
    }
  }

  void _initiateOnlinePayment(PaymentEntity payment, ThemeData theme) {
    if (payment.cashfreeOrderResponse != null) {
      final session = CFSession(
        orderId: payment.cashfreeOrderResponse!.orderId,
        payment_session_id: payment.cashfreeOrderResponse!.paymentSessionId,
        environment: CFEnvironment.SANDBOX, // Change to PRODUCTION for live
      );

      final cFTheme = CFTheme(
        navigationBarBackgroundColor:
            theme.colorScheme.primary.value.toString(),
        navigationBarTextColor: theme.colorScheme.onPrimary.value.toString(),
        buttonBackgroundColor: theme.colorScheme.primary.value.toString(),
        buttonTextColor: theme.colorScheme.onPrimary.value.toString(),
      );

      CashfreePG.doPayment(session, theme).then((result) {
        if (result != null) {
          final isSuccess = result['txStatus'] == 'SUCCESS';
          context.read<CheckoutBloc>().add(
            CheckoutOnlinePaymentCompleted(
              paymentId: payment.id,
              isSuccess: isSuccess,
            ),
          );
        } else {
          context.read<CheckoutBloc>().add(
            CheckoutOnlinePaymentCompleted(
              paymentId: payment.id,
              isSuccess: false,
            ),
          );
        }
      });
    }
  }

  void _showCashPaymentConfirmation(
    CheckoutCashPaymentConfirmationState state,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Cash Payment'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total Amount: ₹${state.payment.amount.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please confirm that the cash payment has been received.',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<CheckoutBloc>().add(const CheckoutReset());
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<CheckoutBloc>().add(
                    CheckoutCashPaymentConfirmed(
                      paymentId: state.payment.paymentId,
                    ),
                  );
                },
                child: const Text('Confirm Payment'),
              ),
            ],
          ),
    );
  }

  void _handleCheckoutSuccess(CheckoutSuccessState state) {
    // Navigate to orders screen
    Navigator.of(context).pushReplacementNamed('/orders');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => ErrorDialog(
            message: message,
            onRetry: () {
              context.read<CheckoutBloc>().add(const CheckoutRetryPayment());
            },
          ),
    );
  }

  void _handleProceedToPayment(CheckoutLoadedState state) {
    if (state.selectedPaymentMode == PaymentMode.cash) {
      // For cash payments, show confirmation directly
      context.read<CheckoutBloc>().add(
        CheckoutCashPaymentConfirmed(paymentId: state.payment.paymentId),
      );
    } else {
      // Create payment for online mode
      context.read<CheckoutBloc>().add(
        CheckoutPaymentCreated(
          amount: state.totalAmount,
          paymentMode: state.selectedPaymentMode!,
        ),
      );
    }
  }

  bool _canProceedToPayment(CheckoutLoadedState state) {
    return state.selectedPaymentMode != null &&
        state.selectedAgentId != null &&
        state.cartItems.isNotEmpty;
  }

  bool _isLoading(CheckoutState state) {
    return state is CheckoutPaymentCreatingState ||
        state is CheckoutOrderCreatingState ||
        state is CheckoutOnlinePaymentInProgressState;
  }
}
