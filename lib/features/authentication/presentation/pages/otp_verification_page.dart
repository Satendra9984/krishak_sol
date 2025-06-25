import 'package:bhoomi_sakti/app/router/app_route_paths.dart';
import 'package:bhoomi_sakti/common/app_common_providers.dart';
import 'package:bhoomi_sakti/features/authentication/domain/entities/otp_verification_type.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/features/authentication/auth_providers.dart';
import 'package:bhoomi_sakti/features/authentication/presentation/blocs/otp_verification/verify_otp_bloc.dart';
import 'package:bhoomi_sakti/features/authentication/presentation/blocs/otp_verification/verify_otp_event.dart';
import 'package:bhoomi_sakti/features/authentication/presentation/blocs/otp_verification/verify_otp_state.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:pinput/pinput.dart';

class OtpVerificationPage extends ConsumerStatefulWidget {
  final String mobileNumber;
  final OtpFlowType flowType;

  const OtpVerificationPage({
    super.key,
    required this.mobileNumber,
    required this.flowType,
  });

  @override
  ConsumerState<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  Timer? _timer;
  final ValueNotifier<int> _resendTimerSeconds = ValueNotifier<int>(60);
  bool _canResendOtp = false;

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  void startResendTimer() {
    _canResendOtp = false;
    _resendTimerSeconds.value = 60; // Reset timer duration
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendTimerSeconds.value > 0) {
            _resendTimerSeconds.value--;
          } else {
            _timer?.cancel();
            _canResendOtp = true;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onVerifyOtpPressed() {
    if (_formKey.currentState!.validate()) {
      // widget.mobileNumber should always be available here due to constructor requirements
      ref
          .read(verifyOtpBlocProvider)
          .add(
            VerifyOtpButtonPressed(
              mobileNumber: widget.mobileNumber,
              otp: _otpController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    const gap = 12.0;
    // final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final colorTheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              if (widget.flowType == OtpFlowType.login) {
                context.replace(AppRoutePaths.login);
              } else {
                context.replace(AppRoutePaths.signUp);
              }
            }
          },
          icon: Icon(Icons.arrow_back, color: colorTheme.onSecondary),
        ),
      ),
      backgroundColor: colorTheme.surface,
      body: BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
        bloc: ref.watch(verifyOtpBlocProvider),
        listener: (context, state) {
          if (state is VerifyOtpFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'OTP Verification Failed: ${state.failure.message}',
                ),
              ),
            );
          } else if (state is VerifyOtpSuccess) {
            // Check if it's a resend scenario, maybe by a flag if needed
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP Verified Successfully!')),
            );

            ref
                .read(authNotifierProvider.notifier)
                .setAuthenticatedUser(state.authSuccessEntity.user);

            context.go(AppRoutePaths.home);
          }
          // VerifyOtpSuccess is handled by AuthNotifier & GoRouter redirect
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Check Your Messages',
                      style: textTheme.headlineMedium,
                    ),

                    const SizedBox(height: gap),
                    Text(
                      'A 6 digit OTP has been sent to your mobile number +91-${widget.mobileNumber}',
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: gap * 2),
                    Pinput(
                      controller: _otpController,
                      length: 6,
                      autofocus: true,
                      defaultPinTheme: PinTheme(
                        width: 48,
                        height: 52,
                        textStyle: textTheme.titleLarge?.copyWith(
                          color: colorTheme.onSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffDFDDDD),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorTheme.primary.withValues(
                              alpha: (0.5 * 255),
                            ),
                            width: 1.5,
                          ),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 48,
                        height: 52,
                        textStyle: textTheme.titleLarge?.copyWith(
                          color: colorTheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffDFDDDD),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: colorTheme.primary,
                            width: 2.2,
                          ),
                        ),
                      ),
                      errorPinTheme: PinTheme(
                        width: 48,
                        height: 52,
                        textStyle: textTheme.bodyMedium?.copyWith(
                          color: colorTheme.error,
                          // fontWeight: FontWeight.bold,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffDFDDDD),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colorTheme.error, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the OTP';
                        }
                        if (value.length != 6) {
                          return 'OTP must be 6 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: gap * 2),

                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          BlocBuilder<VerifyOtpBloc, VerifyOtpState>(
                            bloc: ref.watch(verifyOtpBlocProvider),
                            builder: (context, state) {
                              if (state is VerifyOtpLoading) {
                                return const CircularProgressIndicator();
                              }
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _onVerifyOtpPressed,
                                  child: Text(
                                    'Verify OTP',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: colorTheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: gap * 2),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "Haven't get the OTP yet? ",
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade500,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Resend OTP ',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorTheme.primary,
                                        decoration: TextDecoration.underline,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        decorationColor: colorTheme.primary,
                                      ),
                                      recognizer:
                                          TapGestureRecognizer()
                                            ..onTap = () {
                                              if (state
                                                  is VerifyOtpResendLoading) {
                                                return;
                                              }
                                              context.replace(
                                                AppRoutePaths.signUp,
                                              );
                                            },
                                    ),
                                  ],
                                ),
                              ),
                              if (!_canResendOtp)
                                BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
                                  listener: (context, state) {
                                    if (state is VerifyOtpResendFailure) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(state.failure.message),
                                          backgroundColor: colorTheme.error,
                                        ),
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is VerifyOtpResendLoading) {
                                      return const CircularProgressIndicator();
                                    }
                                    return ValueListenableBuilder(
                                      valueListenable: _resendTimerSeconds,
                                      builder: (context, value, child) {
                                        return Text(
                                          'in $value s',
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: colorTheme.onSurface,
                                          ),
                                          textDirection: TextDirection.ltr,
                                        );
                                      },
                                    );
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          // VerifyOtpSuccess is handled by AuthNotifier & GoRouter redirect
        },
      ),
    );
  }
}
