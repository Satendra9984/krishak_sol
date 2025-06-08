import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/onboarding_bloc.dart';
import 'package:bhoomi_sakti/features/auth/auth_providers.dart'; // For onboardingBlocProvider

// --- Onboarding Item Data Structure (as defined earlier) ---
class OnboardingItemData {
  final String imagePath; // Placeholder, will use Icon for now
  final String title;
  final String subtitle;
  final IconData iconData; // Using IconData as placeholder for imagePath

  OnboardingItemData({
    required this.imagePath, // Keep for future asset integration
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
// --- End Onboarding Item Data Structure ---

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PageController pageController = PageController();
    final onboardingBloc = ref.watch(onboardingBlocProvider);

    return Scaffold(
      body: BlocListener<OnboardingBloc, OnboardingState>(
        bloc: onboardingBloc,
        listener: (context, state) {
          if (state is OnboardingCompleted) {
            // GoRouter's redirect logic will handle navigation based on shared_prefs
            // This listener is more for reacting to the BLoC state if needed locally,
            // but primary navigation is deferred to GoRouter.
            // Example: context.go(AppRoutePaths.login);
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
                          (index) => buildDot(index, context, currentPage),
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
                            onboardingBloc.add(OnboardingFinish());
                          }
                        },
                        child: Text(currentPage < onboardingItemsList.length - 1
                            ? 'NEXT'
                            : 'FINISH'),
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

  Widget buildDot(int index, BuildContext context, int currentPage) {
    return Container(
      height: 10,
      width: currentPage == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
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
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(iconData, size: 150, color: Theme.of(context).primaryColor),
          const SizedBox(height: 30),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 15),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
