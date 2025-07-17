import 'package:bhoomi_sakti/features/authentication/domain/entities/otp_request_entity.dart';

class OtpRequestModel extends OtpRequestEntity {
  const OtpRequestModel({required super.mobileNumber, super.name});

  factory OtpRequestModel.fromEntity(OtpRequestEntity entity) {
    return OtpRequestModel(
      mobileNumber: entity.mobileNumber,
      name: entity.name,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'mobileNumber': mobileNumber};
    if (name != null) {
      data['name'] = name;
    }
    return data;
  }
}
