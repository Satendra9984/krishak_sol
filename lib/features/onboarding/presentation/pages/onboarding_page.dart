import 'package:bhoomi_sakti/app/router/app_route_paths.dart';
import 'package:bhoomi_sakti/features/onboarding/presentation/widdgets/onboarding_screen_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhoomi_sakti/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:go_router/go_router.dart';

class OnboardingItemData {
  final String imagePath;
  final String title;
  final String subtitle;
  final IconData iconData;

  OnboardingItemData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.iconData,
  });
}

final List<OnboardingItemData> onboardingItemsList = [
  OnboardingItemData(
    imagePath: 'assets/images/onboarding_farm.png',
    iconData: Icons.agriculture,
    title: 'Welcome to Bhoomi Shakti!',
    subtitle: 'Empowering farmers with technology for a brighter future.',
  ),
  OnboardingItemData(
    imagePath: 'assets/images/onboarding_soil.png',
    iconData: Icons.eco,
    title: 'Understand Your Soil',
    subtitle: 'Get quick and accurate soil testing results at your fingertips.',
  ),
  OnboardingItemData(
    imagePath: 'assets/images/onboarding_advisor.png',
    iconData: Icons.support_agent,
    title: 'Expert Crop Advisory',
    subtitle: 'Receive personalized guidance to boost your crop yield.',
  ),
];

class OnboardingPage extends StatefulWidget {
  OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Trigger initial state
    context.read<OnboardingBloc>().add(OnboardingStarted());
  }

  @override
  Widget build(BuildContext context) {
    // final onboardingBloc = ref.watch(onboardingBlocProvider);

    return Scaffold(
      body: BlocListener<OnboardingBloc, OnboardingState>(
        // bloc: onboardingBloc,
        listener: (context, state) {
          if (state is OnboardingInProgress) {
            debugPrint(
              '[onboarding_page]: Pagee changed to ${state.currentPage}',
            );
          }
          if (state is OnboardingCompleted) {
            // Navigation is handled by the router's redirect logic
            debugPrint('[onboarding_page]: Onboarding completed');
            context.go(AppRoutePaths.signUp);
          }
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: onboardingItemsList.length,
              onPageChanged: (index) {
                context.read<OnboardingBloc>().add(
                  OnboardingPageChanged(index),
                );
              },
              itemBuilder: (context, index) {
                final item = onboardingItemsList[index];
                return OnboardingScreenItem(
                  iconData: item.iconData,
                  title: item.title,
                  subtitle: item.subtitle,
                );
              },
            ),
            Positioned(
              bottom: 30.0,
              left: 20.0,
              right: 20.0,
              child: BlocBuilder<OnboardingBloc, OnboardingState>(
                // bloc: onboardingBloc,
                builder: (context, state) {
                  int currentPage = 0;
                  if (state is OnboardingInProgress) {
                    currentPage = state.currentPage;
                  }

                  debugPrint('[onboarding_page]: Current page $currentPage');
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.read<OnboardingBloc>().add(OnboardingSkip());
                        },
                        child: const Text('SKIP'),
                      ),
                      Row(
                        children: List.generate(onboardingItemsList.length, (
                          index,
                        ) {
                          // debugPrint(
                          //   '[onboarding_page.dart]: Current page $currentPage index $index',
                          // );
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  currentPage == index
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[300],
                            ),
                          );
                        }),
                      ),
                      TextButton(
                        onPressed: () {
                          if (currentPage < onboardingItemsList.length - 1) {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          } else {
                            context.read<OnboardingBloc>().add(
                              OnboardingComplete(),
                            );
                          }
                        },
                        child: Text(
                          currentPage == onboardingItemsList.length - 1
                              ? 'GET STARTED'
                              : 'NEXT',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
