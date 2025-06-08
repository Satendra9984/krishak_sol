import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/features/auth/auth_providers.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/verify_otp_bloc.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/verify_otp_event.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/verify_otp_state.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/login_bloc.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/login_event.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/login_state.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/signup_bloc.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/signup_event.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/signup_state.dart';
import 'dart:async';
import 'package:pinput/pinput.dart';

enum OtpFlowType { login, signup }

class OtpVerificationPage extends ConsumerStatefulWidget {
  final String mobileNumber;
  final OtpFlowType flowType;

  const OtpVerificationPage({
    super.key,
    required this.mobileNumber,
    required this.flowType,
  });

  @override
  ConsumerState<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  Timer? _timer;
  int _resendTimerSeconds = 30;
  bool _canResendOtp = false;

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  void startResendTimer() {
    _canResendOtp = false;
    _resendTimerSeconds = 30; // Reset timer duration
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendTimerSeconds > 0) {
            _resendTimerSeconds--;
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
      ref.read(verifyOtpBlocProvider).add(
            VerifyOtpButtonPressed(
              mobileNumber: widget.mobileNumber,
              otp: _otpController.text,
            ),
          );
    }
  }

  void _onResendOtpPressed() {
    if (_canResendOtp) {
      startResendTimer(); // Restart timer
      if (widget.flowType == OtpFlowType.login) {
        ref.read(loginBlocProvider).add(ResendLoginOtp(mobileNumber: widget.mobileNumber));
      } else if (widget.flowType == OtpFlowType.signup) {
        // For signup resend, we pass an empty name as discussed.
        // This might need adjustment based on backend behavior.
        ref.read(signupBlocProvider).add(ResendSignupOtp(mobileNumber: widget.mobileNumber));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: MultiBlocListener(
        listeners: [
          BlocListener<VerifyOtpBloc, VerifyOtpState>(
            bloc: ref.watch(verifyOtpBlocProvider),
            listener: (context, state) {
              if (state is VerifyOtpFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('OTP Verification Failed: ${state.failure.message}')),
                );
              }
              // VerifyOtpSuccess is handled by AuthNotifier & GoRouter redirect
            },
          ),
          BlocListener<LoginBloc, LoginState>(
            bloc: ref.watch(loginBlocProvider),
            listener: (context, state) {
              if (state is LoginOtpSentSuccess) {
                 // Check if it's a resend scenario, maybe by a flag if needed
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('OTP Resent Successfully!')),
                );
              } else if (state is LoginFailure) {
                 // Differentiate from initial send failure if necessary
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to Resend OTP: ${state.failure.message}')),
                );
              }
            },
          ),
          BlocListener<SignupBloc, SignupState>(
            bloc: ref.watch(signupBlocProvider),
            listener: (context, state) {
              if (state is SignupOtpSentSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('OTP Resent Successfully!')),
                );
              } else if (state is SignupFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to Resend OTP: ${state.failure.message}')),
                );
              }
            },
          ),
        ],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Enter OTP sent to ${widget.mobileNumber}'),
                  const SizedBox(height: 20),
                  Pinput(
                    controller: _otpController,
                    length: 6,
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the OTP';
                      }
                      if (value.length != 6) {
                        return 'OTP must be 6 digits';
                      }
                      return null;
                    },
                    // You can customize the appearance further using `defaultPinTheme`, `focusedPinTheme`, etc.
                    // Example defaultPinTheme:
                    // defaultPinTheme: PinTheme(
                    //   width: 56,
                    //   height: 56,
                    //   textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
                    //     borderRadius: BorderRadius.circular(20),
                    //   ),
                    // ),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<VerifyOtpBloc, VerifyOtpState>(
                    bloc: ref.watch(verifyOtpBlocProvider),
                    builder: (context, state) {
                      if (state is VerifyOtpLoading) {
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: _onVerifyOtpPressed,
                        child: const Text('Verify OTP'),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _canResendOtp ? _onResendOtpPressed : null,
                    child: Text(
                      _canResendOtp 
                          ? 'Resend OTP' 
                          : 'Resend OTP in $_resendTimerSeconds s',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
