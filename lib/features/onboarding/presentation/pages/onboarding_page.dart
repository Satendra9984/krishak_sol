import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/features/onboarding/onboarding_providers.dart';
import 'package:bhoomi_sakti/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_bloc.dart';

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

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = PageController();
    final onboardingBloc = ref.watch(onboardingBlocProvider);

    return Scaffold(
      body: BlocListener<OnboardingBloc, OnboardingState>(
        bloc: onboardingBloc,
        listener: (context, state) {
          if (state is OnboardingCompleted) {
            // Navigation is handled by the router's redirect logic
          }
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: onboardingItemsList.length,
              onPageChanged: (index) {
                onboardingBloc.add(OnboardingPageChanged(index));
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
                bloc: onboardingBloc,
                builder: (context, state) {
                  int currentPage = 0;
                  if (state is OnboardingInProgress) {
                    currentPage = state.currentPage;
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          onboardingBloc.add(OnboardingSkip());
                        },
                        child: const Text('SKIP'),
                      ),
                      Row(
                        children: List.generate(
                          onboardingItemsList.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentPage == index
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (currentPage < onboardingItemsList.length - 1) {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          } else {
                            onboardingBloc.add(OnboardingComplete());
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

class OnboardingScreenItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String subtitle;

  const OnboardingScreenItem({
    super.key,
    required this.iconData,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 120,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 32.0),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
