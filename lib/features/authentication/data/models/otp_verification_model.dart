import 'package:bhoomi_sakti/features/auth/domain/entities/otp_verification_entity.dart';

class OtpVerificationModel extends OtpVerificationEntity {
  const OtpVerificationModel({
    required super.mobileNumber,
    required super.otp,
  });

  factory OtpVerificationModel.fromEntity(OtpVerificationEntity entity) {
    return OtpVerificationModel(
      mobileNumber: entity.mobileNumber,
      otp: entity.otp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mobileNumber': mobileNumber,
      'otp': otp,
    };
  }
}
