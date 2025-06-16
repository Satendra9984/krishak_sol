import 'package:bhoomi_sakti/common/widgets/custom_text_field.dart';
import 'package:bhoomi_sakti/features/authentication/domain/entities/otp_verification_type.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/features/authentication/auth_providers.dart';
import 'package:bhoomi_sakti/features/authentication/presentation/blocs/login/login_bloc.dart';
import 'package:bhoomi_sakti/features/authentication/presentation/blocs/login/login_event.dart';
import 'package:bhoomi_sakti/features/authentication/presentation/blocs/login/login_state.dart';
import 'package:bhoomi_sakti/features/authentication/presentation/pages/otp_verification_page.dart'; // For OtpFlowType
import 'package:go_router/go_router.dart';
import 'package:bhoomi_sakti/app/router/app_route_paths.dart';

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
      ref
          .read(loginBlocProvider)
          .add(LoginButtonPressed(mobileNumber: _mobileController.text));
    }
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    if (value.length < 10) {
      return 'Mobile number must be at least 10 digits';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Listen to AuthNotifier for navigation after successful login
    // This is handled by GoRouter's redirect logic based on AuthState

    const gap = 12.0;
    // final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final colorTheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      // appBar: AppBar(title: const Text('Login')),
      backgroundColor: colorTheme.surface,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back",
                        style: textTheme.headlineMedium,
                        maxLines: 2,
                        softWrap: true,
                      ),
                      const SizedBox(height: gap / 3),
                      Text(
                        // ignore: lines_longer_than_80_chars
                        'Great to have you back',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: gap * 2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFormField(
                        controller: _mobileController,
                        labelText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        validator: _validateMobile,
                        hintText: '+91-1234567890',
                      ),
                      const SizedBox(height: gap * 3),

                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _onLoginPressed,
                                  icon:
                                      state is LoginLoading
                                          ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.white,
                                              color: Colors.white,
                                            ),
                                          )
                                          : const SizedBox.shrink(),

                                  label: Text(
                                    'Login',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: colorTheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: gap * 2),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(child: SizedBox.shrink()),
                                  Expanded(
                                    child: Divider(color: Color(0xffe1e1e1)),
                                  ),
                                  Text(
                                    '  Or  ',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: Color(0xffe1e1e1),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: Color(0xffe1e1e1)),
                                  ),
                                  Expanded(child: SizedBox.shrink()),
                                ],
                              ),

                              const SizedBox(height: gap * 2),

                              RichText(
                                text: TextSpan(
                                  text: "Dont't have an account? ",
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade500,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Sign Up',
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
                                              if (state is LoginLoading) {
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
                            ],
                          );
                        },
                      ),
                    ],
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
