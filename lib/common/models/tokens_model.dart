import 'package:bhoomi_sakti/common/auth/entities/tokens_entity.dart';

class TokensModel extends TokensEntity {
  const TokensModel({
    required super.accessToken,
    required super.refreshToken,
    super.accessExpiry,
    super.refreshExpiry,
  });

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(
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

  TokensEntity toEntity() {
    return TokensEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessExpiry: accessExpiry,
      refreshExpiry: refreshExpiry,
    );
  }
}
