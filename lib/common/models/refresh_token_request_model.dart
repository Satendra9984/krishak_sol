class RefreshTokenRequestModel {
  final String refreshToken;

  const RefreshTokenRequestModel({required this.refreshToken});

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }
}
