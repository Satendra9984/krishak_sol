import 'package:equatable/equatable.dart';

class TokensEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime? accessExpiry;
  final DateTime? refreshExpiry;

  const TokensEntity({
    required this.accessToken,
    required this.refreshToken,
    this.accessExpiry,
    this.refreshExpiry,
  });

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        accessExpiry,
        refreshExpiry,
      ];
}
