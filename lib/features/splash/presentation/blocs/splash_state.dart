part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {
  final AppConfig config;
  const SplashLoaded(this.config);

  @override
  List<Object?> get props => [config];
}

class SplashFailure extends SplashState {
  final Failure failure;
  const SplashFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}

/// Navigation states for routing from splash
class NavigateToOnboarding extends SplashState {}

class NavigateToAuth extends SplashState {}

class NavigateToHome extends SplashState {
  final UserEntity user;
  const NavigateToHome(this.user);

  @override
  List<Object?> get props => [user];
}
