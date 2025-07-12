// lib/features/checkout/presentation/screens/checkout_screen.dart

import 'package:bhoomi_sakti/app/config/theme/app_colors.dart';
import 'package:bhoomi_sakti/features/payment/domain/entities/payment_entity.dart';
import 'package:bhoomi_sakti/features/payment/presentation/providers/bloc/checkout_bloc.dart';
import 'package:bhoomi_sakti/features/payment/presentation/widgets/checkout_app.dart';
import 'package:bhoomi_sakti/features/payment/presentation/widgets/checkout_bottom_bar.dart';
import 'package:bhoomi_sakti/features/payment/presentation/widgets/checkout_item_list.dart';
import 'package:bhoomi_sakti/features/payment/presentation/widgets/payment_summary.dart';
import 'package:bhoomi_sakti/features/payment/presentation/widgets/payments_selector.dart';

import 'package:bhoomi_sakti/features/payment/domain/entities/payment_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
// import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';

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
        listener: (context, state) {
          _handleStateChanges(context, state, theme);
        },
        builder: (context, state) {
          return Stack(
            children: [
              _buildContent(state, theme),
              // if (_isLoading(state))
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
              onProceedToPayment: () {
                context.read<CheckoutBloc>().add(
                  CheckoutPaymentCreated(
                    amount: state.totalAmount,
                    paymentMode: state.selectedPaymentMode!,
                  ),
                );
              },
              isEnabled:
                  state.selectedPaymentMode != null &&
                  state.selectedAgentId != null &&
                  state.cartItems.isNotEmpty,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _handleStateChanges(
    BuildContext context,
    CheckoutState state,
    ThemeData theme,
  ) {
    switch (state) {
      case CheckoutPaymentCreatedState():
        _handlePaymentCreated(state, theme);
        break;

      case CheckoutSuccessState():
        _handleCheckoutSuccess(state);
        break;

      case CheckoutErrorState():
        _showErrorDialog(state.message);
        break;

      case _:
        break;
    }
  }

  Widget _buildContent(CheckoutState state, ThemeData theme) {
    return switch (state) {
      CheckoutInitialState() || CheckoutLoadingState() => const Center(
        child: CircularProgressIndicator(),
      ),
      CheckoutLoadedState() => _buildCheckoutContent(state, theme),
      CheckoutErrorState() => _buildErrorContent(state, theme),
      CheckoutPaymentFailedState() => _buildPaymentFailedContent(state, theme),
      _ => const SizedBox.shrink(),
    };
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
          // _buildSectionTitle('Select Agent', theme),
          // const SizedBox(height: 24),

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
              context.read<CheckoutBloc>().add(
                CheckoutRetryPayment(agentId: widget.agentId),
              );
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
              context.read<CheckoutBloc>().add(
                CheckoutRetryPayment(agentId: widget.agentId),
              );
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _handlePaymentCreated(
    CheckoutPaymentCreatedState state,
    ThemeData theme,
  ) {
    if (state.payment.paymentMode == PaymentMode.online) {
      _initiateOnlinePayment(state.payment, theme);
    } else {
      // For cash payments, show confirmation screen
      // This will be handled by the bloc state change
      // _showCashPaymentConfirmation(state, theme);
      context.read<CheckoutBloc>().add(
        CheckoutOrderConfirmed(payment: state.payment),
      );
    }
  }

  void _initiateOnlinePayment(PaymentEntity payment, ThemeData theme) {
    context.read<CheckoutBloc>().add(
      CheckoutOnlinePaymentCompleted(payment: payment, isSuccess: true),
    );
  }

  void _showCashPaymentConfirmation(
    CheckoutCashPaymentConfirmationState state,
    ThemeData theme,
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
                  context.pop();
                  context.read<CheckoutBloc>().add(const CheckoutReset());
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pop();
                  // context.read<CheckoutBloc>().add(
                  //   CheckoutOrderConfirmed(payment: state.payment),
                  // );
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
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  context.read<CheckoutBloc>().add(
                    CheckoutRetryPayment(agentId: widget.agentId),
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
    );
  }

  bool _isLoading(CheckoutState state) {
    return state is CheckoutPaymentCreatingState ||
        state is CheckoutOrderCreatingState ||
        state is CheckoutOnlinePaymentInProgressState;
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
}
