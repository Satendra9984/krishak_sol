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

  factory TokensEntity.fromJson(Map<String, dynamic> json) {
    return TokensEntity(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      accessExpiry:
          json['accessExpiry'] != null
              ? DateTime.tryParse(json['accessExpiry'] as String)
              : null,
      refreshExpiry:
          json['refreshExpiry'] != null
              ? DateTime.tryParse(json['refreshExpiry'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'accessExpiry': accessExpiry?.toIso8601String(),
      'refreshExpiry': refreshExpiry?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    accessToken,
    refreshToken,
    accessExpiry,
    refreshExpiry,
  ];
}
