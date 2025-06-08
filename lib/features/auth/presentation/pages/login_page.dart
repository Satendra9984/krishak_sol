import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/features/auth/auth_providers.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/login_bloc.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/login_event.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/login_state.dart';
import 'package:bhoomi_sakti/features/auth/presentation/pages/otp_verification_page.dart'; // For OtpFlowType
import 'package:go_router/go_router.dart';
import 'package:bhoomi_sakti/app/config/router/app_route_paths.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      ref.read(loginBlocProvider).add(
            LoginButtonPressed(
              mobileNumber: _mobileController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to AuthNotifier for navigation after successful login
    // This is handled by GoRouter's redirect logic based on AuthState

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocListener<LoginBloc, LoginState>(
        bloc: ref.watch(loginBlocProvider),
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login Failed: ${state.failure.message}')),
            );
          } else if (state is LoginOtpSentSuccess) {
            // Navigate to OTP verification page
            context.goNamed(
              AppRoutePaths.otpVerification,
              extra: {
                'mobileNumber': _mobileController.text,
                'flowType': OtpFlowType.login,
              },
            );
          }
          // Successful login (after OTP verification) is handled by AuthNotifier updating global state,
          // which GoRouter listens to for redirection.
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
                    controller: _mobileController,
                    decoration: const InputDecoration(labelText: 'Mobile Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      if (value.length != 10) { // Basic validation
                        return 'Mobile number must be 10 digits';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),
                  BlocBuilder<LoginBloc, LoginState>(
                    bloc: ref.watch(loginBlocProvider),
                    builder: (context, state) {
                      if (state is LoginLoading) {
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: _onLoginPressed,
                        child: const Text('Send OTP'),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Navigate to Signup page
                      context.go(AppRoutePaths.signUp);
                    },
                    child: const Text('Don\'t have an account? Sign Up'),
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
