import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bhoomi_sakti/app/router/app_route_paths.dart';
import 'package:bhoomi_sakti/features/auth/auth_providers.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/signup/signup_bloc.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/signup/signup_event.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/signup/signup_state.dart';
import 'package:bhoomi_sakti/features/auth/presentation/pages/otp_verification_page.dart'; // For OtpFlowType

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _onSignupPressed() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(signupBlocProvider)
          .add(
            SignupButtonPressed(
              name: _nameController.text,
              mobileNumber: _mobileController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: BlocListener<SignupBloc, SignupState>(
        bloc: ref.watch(signupBlocProvider),
        listener: (context, state) {
          if (state is SignupFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Signup Failed: ${state.failure.message}'),
              ),
            );
          } else if (state is SignupOtpSentSuccess) {
            // Navigate to OTP verification page
            context.goNamed(
              AppRoutePaths.otpVerification,
              extra: {
                'mobileNumber': _mobileController.text,
                'flowType': OtpFlowType.signup,
              },
            );
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _mobileController,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      if (value.length != 10) {
                        // Basic validation
                        return 'Mobile number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<SignupBloc, SignupState>(
                    bloc: ref.watch(signupBlocProvider),
                    builder: (context, state) {
                      if (state is SignupLoading) {
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: _onSignupPressed,
                        child: const Text('Send OTP'),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      context.go(AppRoutePaths.login);
                    },
                    child: const Text('Already have an account? Login'),
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
