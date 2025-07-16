// lib/features/checkout/presentation/screens/checkout_screen.dart

import 'package:bhoomi_sakti/app/config/theme/app_colors.dart';
import 'package:bhoomi_sakti/common/app_common_providers.dart';
import 'package:bhoomi_sakti/features/cart/cart_providers.dart';
import 'package:bhoomi_sakti/features/checkout/domain/entities/payment_entity.dart';
import 'package:bhoomi_sakti/features/checkout/payments_providers.dart';
import 'package:bhoomi_sakti/features/checkout/presentation/providers/bloc/checkout_bloc.dart';
import 'package:bhoomi_sakti/features/checkout/presentation/widgets/checkout_app.dart';
import 'package:bhoomi_sakti/features/checkout/presentation/widgets/checkout_bottom_bar.dart';
import 'package:bhoomi_sakti/features/checkout/presentation/widgets/checkout_item_list.dart';
import 'package:bhoomi_sakti/features/checkout/presentation/widgets/payment_summary.dart';
import 'package:bhoomi_sakti/features/checkout/presentation/widgets/payments_selector.dart';

import 'package:bhoomi_sakti/features/checkout/domain/entities/payment_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
// import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({Key? key, required this.agentId}) : super(key: key);

  final String agentId;

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize through Riverpod
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(checkoutBlocProvider)
          .add(CheckoutInitialize(agentId: widget.agentId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // backgroundColor: AppColors.background,
      appBar: const CheckoutAppBar(),
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        bloc: ref.watch(checkoutBlocProvider),
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
        bloc: ref.watch(checkoutBlocProvider),
        builder: (context, state) {
          if (state is CheckoutLoadedState) {
            return CheckoutBottomBar(
              totalAmount: state.totalAmount,
              selectedPaymentMode: state.selectedPaymentMode,
              onProceedToPayment: () {
                ref
                    .read(checkoutBlocProvider)
                    .add(
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
        _showErrorDialog(state.message, ref.read(checkoutBlocProvider));
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
      CheckoutSuccessState() => _buildCheckoutSuccessContent(state, theme),
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
          // Address
          _buildSectionTitle('Address', theme),
          const SizedBox(height: 12),

          Consumer(
            builder: (context, ref, child) {
              final user = ref.watch(currentUserProvider);
              if (user == null) {
                return const SizedBox.shrink();
              }
              return ListTile(
                tileColor: Color(0xffF8F9FE),
                leading: Icon(
                  FontAwesomeIcons.locationDot,
                  color: Color(0xff3657AD),
                  size: 16,
                ),
                title: Text(user.location ?? 'Address not available'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Navigate to edit address screen
                },
              );
            },
          ),

          const SizedBox(height: 24),

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
              ref
                  .read(checkoutBlocProvider)
                  .add(CheckoutPaymentMethodSelected(paymentMode: paymentMode));
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

  Widget _buildCheckoutSuccessContent(
    CheckoutSuccessState state,
    ThemeData data,
  ) {
    return Column(
      children: [
        Icon(Icons.check_circle, size: 64, color: AppColors.success),
        const SizedBox(height: 16),
        Text(
          'Order Placed Successfully',
          style: data.textTheme.titleMedium!.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        // back or go to orders screen
        ElevatedButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
          child: const Text('Back to Home'),
        ),

        ElevatedButton(
          onPressed: () {
            context.go('/orders');
          },
          child: const Text('Go to Orders'),
        ),
      ],
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
              ref
                  .read(checkoutBlocProvider)
                  .add(CheckoutRetryPayment(agentId: widget.agentId));
            },
            child: const Text('Retry'),
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
      ref
          .read(checkoutBlocProvider)
          .add(CheckoutOrderConfirmed(payment: state.payment));
    }
  }

  void _initiateOnlinePayment(PaymentEntity payment, ThemeData theme) {
    var cfPaymentGatewayService =
        CFPaymentGatewayService()..setCallback(
          (orderId) {
            ref
                .read(checkoutBlocProvider)
                .add(
                  CheckoutOnlinePaymentCompleted(
                    payment: payment,
                    isSuccess: true,
                  ),
                );
          },
          (oneError, error) {
            ref
                .read(checkoutBlocProvider)
                .add(
                  CheckoutOnlinePaymentCompleted(
                    payment: payment,
                    isSuccess: false,
                  ),
                );
          },
        );
    try {
      var session =
          CFSessionBuilder()
              .setEnvironment(CFEnvironment.SANDBOX)
              .setOrderId(payment.cashfreeOrderResponse!.orderId)
              .setPaymentSessionId(
                payment.cashfreeOrderResponse!.paymentSessionId,
              )
              .build();

      var cfWebCheckout =
          CFWebCheckoutPaymentBuilder().setSession(session).build();
      cfPaymentGatewayService.doPayment(cfWebCheckout);
    } on CFException catch (e) {
      print('[CheckoutPage][CASHFREE PAYMENT FAILED] CFException: $e');
      ref
          .read(checkoutBlocProvider)
          .add(
            CheckoutOnlinePaymentCompleted(payment: payment, isSuccess: false),
          );
    }
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
              ref
                  .read(checkoutBlocProvider)
                  .add(CheckoutRetryPayment(agentId: widget.agentId));
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _handleCheckoutSuccess(CheckoutSuccessState state) {
    // Navigate to orders screen
    // todo: show success message and option to go to orders screen
    // show snackbar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Order placed successfully')));
    // clear cart
    ref.read(checkoutBlocProvider).add(const CheckoutReset());

    if (context.canPop()) {
      context.pop();
    }
  }

  void _showErrorDialog(String message, CheckoutBloc bloc) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              BlocProvider.value(
                value: bloc,
                child: TextButton(
                  onPressed: () {
                    bloc.add(CheckoutRetryPayment(agentId: widget.agentId));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Retry'),
                ),
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


/*
class _MyAppState extends State<MyApp> {

  var cfPaymentGatewayService = CFPaymentGatewayService();

  @override
  void initState() {
    super.initState();
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
  }

  void verifyPayment(String orderId) {
    print("Verify Payment");
  }

  void onError(CFErrorResponse errorResponse, String orderId) {
    print(errorResponse.getMessage());
    print("Error while making payment");
  }

  webCheckout() async {
    try {
      var session = createSession();
      var cfWebCheckout = CFWebCheckoutPaymentBuilder().setSession(session!).build();
      cfPaymentGatewayService.doPayment(cfWebCheckout);
    } on CFException catch (e) {
      print(e.message);
    }

  }

  CFSession? createSession() {
    try {
      var session = CFSessionBuilder().setEnvironment(environment).setOrderId(orderId).setPaymentSessionId(paymentSessionId).build();
      return session;
    } on CFException catch (e) {
      print(e.message);
    }
    return null;
  }
}
*/

/*
Mobile Integration
Flutter Integration
Learn more about integrating Cashfree Flutter SDK in your mobile app

​
Cashfree’s integrity standards
Before proceeding with the SDK integration, please ensure that your application complies with Cashfree’s Integrity. Applications that don’t meet the required integrity standards may be restricted from using production services.

For further guidance, refer to the Cashfree Integrity.

​
Setting up SDK
The Flutter SDK is hosted on pub dev.You can get the sdk here.
Our Flutter SDK supports Android SDK version 19 and above and iOS minimum deployment target of 11 and above.

Open your project’s pubspec.yaml and add the following under dependencies: flutter_cashfree_pg_sdk: 2.2.8+46

iOS
Add this to your application’s info.plist file.


Copy

Ask AI
<key>LSApplicationQueriesSchemes</key>
<array>
<string>phonepe</string>
<string>tez</string>
<string>paytmmp</string>
<string>bhim</string>
<string>credpay</string>
</array>
​
Step 1: Creating an order
The first step in the Cashfree Payment Gateway integration is to create an Order. You need to do this before any payment can be processed. You can add an endpoint to your server which creates this order and is used for communication with your frontend.

API Request for creating an order
Here’s a sample request for creating an order using your desired backend language. Cashfree offers backend SDKs to simplify the integration process.

You can find the SDKs here.


javascript

python

java

go

csharp

php

curl

Copy

Ask AI
import com.cashfree.*;

Cashfree.XClientId = {Client Key};
Cashfree.XClientSecret = {Client Secret Key};
Cashfree.XEnvironment = Cashfree.SANDBOX;

static void createOrder() {
  CustomerDetails customerDetails = new CustomerDetails();
  customerDetails.setCustomerId("123");
  customerDetails.setCustomerPhone("9999999999");

  CreateOrderRequest request = new CreateOrderRequest();
  request.setOrderAmount(1.0);
  request.setOrderCurrency("INR");
  request.setCustomerDetails(customerDetails);
  try {
    Cashfree cashfree = new Cashfree();
    ApiResponse<OrderEntity> response = cashfree.PGCreateOrder("2023-08-01", request, null, null, null);
    System.out.println(response.getData().getOrderId());

  } catch (ApiException e) {
    throw new RuntimeException(e);
  }
}
After successfully creating an order, you will receive a unique order_id and payment_session_id that you need for subsequent steps.

You can view all the complete api request and response for /orders here.

​
Step 2: Opening the payment page
Web Checkout is a streamlined payment solution that integrates Cashfree’s payment gateway into your iOS app through our SDK. This implementation uses a WebView to provide a secure, feature-rich payment experience.

Your customers are presented with a familiar web interface where they can enter their payment details and complete their transaction seamlessly. All payment logic, UI components, and security measures are managed by our SDK, eliminating the need for complex custom implementation.

To complete the payment, we can follow the following steps:

Create a CFSession object.
Create a Web Checkout Payment object.
Set payment callback.
Initiate the payment using the payment object created
​
Create a session
This object contains essential information about the order, including the payment session ID (payment_session_id) and order ID (order_id) obtained from Step 1. It also specifies the environment (sandbox or production).


Copy

Ask AI
try {
    var session = CFSessionBuilder().setEnvironment(environment).setOrderId(orderId).setPaymentSessionId(paymentSessionId).build();
    return session;
} on CFException catch (e) {
    print(e.message);
}
​
Create a web checkout payment object
Use CFWebCheckoutPaymentBuilder to create the payment object. This object acceps a CFSession, like the one created in the previous step.


Copy

Ask AI
var cfWebCheckout = CFWebCheckoutPaymentBuilder()
  .setSession(session!)
  .build();
​
Setup callback
You need to set up callback handlers to handle events after payment processing.


Copy

Ask AI
void verifyPayment(String orderId) {
    print("Verify Payment");
  }

  void onError(CFErrorResponse errorResponse, String orderId) {
    print(errorResponse.getMessage());
    print("Error while making payment");
  }

var cfPaymentGatewayService = CFPaymentGatewayService();

  @override
  void initState() {
    super.initState();
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
}
​
Step 3: Sample Code

Copy

Ask AI
class _MyAppState extends State<MyApp> {

  var cfPaymentGatewayService = CFPaymentGatewayService();

  @override
  void initState() {
    super.initState();
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
  }

  void verifyPayment(String orderId) {
    print("Verify Payment");
  }

  void onError(CFErrorResponse errorResponse, String orderId) {
    print(errorResponse.getMessage());
    print("Error while making payment");
  }

  webCheckout() async {
    try {
      var session = createSession();
      var cfWebCheckout = CFWebCheckoutPaymentBuilder().setSession(session!).build();
      cfPaymentGatewayService.doPayment(cfWebCheckout);
    } on CFException catch (e) {
      print(e.message);
    }

  }

  CFSession? createSession() {
    try {
      var session = CFSessionBuilder().setEnvironment(environment).setOrderId(orderId).setPaymentSessionId(paymentSessionId).build();
      return session;
    } on CFException catch (e) {
      print(e.message);
    }
    return null;
  }
}
​
Step 4: Confirming the payment
Once the payment is completed, you need to confirm whether the payment was successful by checking the order status. Once the payment finishes, the user will be redirected back to your activity.

Ensure you check the order status from your server endpoint.
To verify an order you can call our /pg/orders endpoint from your backend. You can also use our SDK to achieve the same.


golang

javascript

php

java

python

csharp

curl

Copy

Ask AI
import com.cashfree.*;
//other code

try {
    Cashfree.XClientId = "<x-client-id>";
    Cashfree.XClientSecret = "<x-client-secret>";
    Cashfree.XEnvironment = Cashfree.SANDBOX;

    Cashfree cashfree = new Cashfree();
    String xApiVersion = "2023-08-01";

    ApiResponse<OrderEntity> responseFetchOrder = cashfree.PGFetchOrder(xApiVersion, "<order_id>", null, null, null);
    System.out.println(response.getData().getOrderId());
} catch (ApiException e) {
    throw new RuntimeException(e);
}
​
Testing
You should now have a working checkout button that redirects your customer to Cashfree payment page. If your integration isn’t working:

Open the Network tab in your browser’s developer tools.
Click the button and check the console logs.
Use console.log(session) inside your button click listener to confirm the correct error returned.
​
Error codes
To confirm the error returned in your application, you can view the error codes that are exposed by the SDK.

Show list of error codes

​
💻 Quick dev-to-dev talk
You clearly care about building better payment experiences for your clients, here’s a quick tip: Earn additional income doing exactly what you’re doing now!

Join the Cashfree Affiliate Partner Program and get rewarded every time your clients use Cashfree.

What’s in it for you?

Earn up to 0.25% commission on every transaction
Be more than a dev - be the trusted fintech partner for your clients
Get a dedicated partner manager, your go-to expert
What’s in it for your clients?

Instant activation, go live in minutes.
Industry-best success rate across all payment modes.
Effortlessly accept international payments in 140+ currencies
Ready to push to prod? 👉 Become a Partner now
*/