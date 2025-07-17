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
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _locationController.dispose();
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
    const gap = 12.0;
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
                    "Let's get started!",
                    style: textTheme.headlineMedium,
                    maxLines: 2,
                    softWrap: true,
                  ),
                  const SizedBox(height: gap / 3),

                  Text(
                    'Sign up and boost your production',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: gap * 2),

                  CustomTextFormField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },

                    hintText: 'Enter your name',
                    // prefixIcon: Icon(Icons.person_outline_rounded),
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
                    hintText: '+91-1234567890',
                    // prefixIcon: Icon(Icons.phone_outlined),
                  ),

                  CustomTextFormField(
                    controller: _locationController,
                    labelText: 'Location',
                    validator: (value) {
                      // if (value == null || value.isEmpty) {
                      //   return 'Please enter your location';
                      // }
                      return null;
                    },

                    hintText: 'Enter your location',
                    // prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  const SizedBox(height: gap * 3),

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
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: colorTheme.onPrimary,
                                    fontWeight: FontWeight.bold,
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
                                text: "Already have an account? ",
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey.shade500,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Login',
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
