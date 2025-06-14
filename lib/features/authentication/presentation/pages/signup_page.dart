import 'package:bhoomi_sakti/common/widgets/custom_text_field.dart';
import 'package:bhoomi_sakti/features/authentication/domain/entities/otp_verification_type.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bhoomi_sakti/app/router/app_route_paths.dart';
import 'package:bhoomi_sakti/features/authentication/auth_providers.dart';
import 'package:bhoomi_sakti/features/authentication/presentation/blocs/signup/signup_bloc.dart';
import 'package:bhoomi_sakti/features/authentication/presentation/blocs/signup/signup_event.dart';
import 'package:bhoomi_sakti/features/authentication/presentation/blocs/signup/signup_state.dart';
import 'package:bhoomi_sakti/features/authentication/presentation/pages/otp_verification_page.dart'; // For OtpFlowType

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
    const gap = 16.0;
    // final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final colorTheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      // appBar: AppBar(title: const Text('Sign Up')),
      backgroundColor: colorTheme.surface,
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
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Let's Revolutionize Agriculture!",
                    style: textTheme.headlineMedium,
                    maxLines: 2,
                    softWrap: true,
                  ),
                  const SizedBox(height: gap),

                  Text(
                    'Let\'s Begin by Creating your Account',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: gap * 1.25),

                  CustomTextFormField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  const SizedBox(height: gap),

                  CustomTextFormField(
                    controller: _mobileController,
                    labelText: 'Mobile Number',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      if (value.length != 10) {
                        return 'Mobile number must be 10 digits';
                      }
                      return null;
                    },
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  const SizedBox(height: gap * 1.5),

                  BlocBuilder<SignupBloc, SignupState>(
                    bloc: ref.watch(signupBlocProvider),
                    builder: (context, state) {
                      if (state is SignupLoading) {
                        return const CircularProgressIndicator();
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _onSignupPressed,
                                label: Text(
                                  'Sign Up',
                                  style: textTheme.titleMedium?.copyWith(
                                    color: colorTheme.onPrimary,
                                  ),
                                ),
                                icon:
                                    state is SignupLoading
                                        ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.white,
                                            color: Colors.white,
                                          ),
                                        )
                                        : const SizedBox.shrink(),
                              ),
                            ),
                            const SizedBox(height: gap * 1.25),
                            RichText(
                              text: TextSpan(
                                text: "Already have an account? ",
                                style: textTheme.titleMedium?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Login',
                                    style: textTheme.titleMedium,
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            if (state is SignupLoading) {
                                              return;
                                            }
                                            context.replace(
                                              AppRoutePaths.login,
                                            );
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
