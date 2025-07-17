part of 'splash_bloc.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

class LoadSplashEvent extends SplashEvent {}

/// New event to trigger onboarding/auth logic
class AppStarted extends SplashEvent {}
