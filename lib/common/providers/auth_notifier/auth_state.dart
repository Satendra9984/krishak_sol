import 'package:bhoomi_sakti/common/auth/entities/tokens_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:bhoomi_sakti/common/auth/entities/user_entity.dart';
import 'package:bhoomi_sakti/app/core/error/app_failures.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final UserEntity user;
  final TokensEntity tokens;

  const Authenticated({required this.user, required this.tokens});

  @override
  List<Object?> get props => [user, tokens];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthFailureState extends AuthState {
  final Failure failure;

  const AuthFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
