part of 'onboarding_bloc.dart';

@immutable
abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInProgress extends OnboardingState {
  final int currentPage;
  const OnboardingInProgress(this.currentPage);

  @override
  List<Object> get props => [currentPage];
}

// Indicates onboarding is done, and app should proceed to login/home
class OnboardingCompleted extends OnboardingState {}
