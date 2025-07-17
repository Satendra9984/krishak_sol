class OnboardingStatus {
  final bool isCompleted;
  final int currentPage;

  const OnboardingStatus({
    required this.isCompleted,
    required this.currentPage,
  });

  OnboardingStatus copyWith({bool? isCompleted, int? currentPage}) {
    return OnboardingStatus(
      isCompleted: isCompleted ?? this.isCompleted,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
