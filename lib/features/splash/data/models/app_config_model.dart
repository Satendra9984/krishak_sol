import 'package:bhoomi_sakti/features/splash/domain/entities/app_config.dart';

class AppConfigModel extends AppConfig {
  const AppConfigModel({
    required bool isFirstLaunch,
    required bool isUpdateRequired,
    required String currentVersion,
    String? latestVersion,
    String? updateUrl,
  }) : super(
          isFirstLaunch: isFirstLaunch,
          isUpdateRequired: isUpdateRequired,
          currentVersion: currentVersion,
          latestVersion: latestVersion,
          updateUrl: updateUrl,
        );

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      isFirstLaunch: json['isFirstLaunch'] as bool,
      isUpdateRequired: json['isUpdateRequired'] as bool,
      currentVersion: json['currentVersion'] as String,
      latestVersion: json['latestVersion'] as String?,
      updateUrl: json['updateUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isFirstLaunch': isFirstLaunch,
      'isUpdateRequired': isUpdateRequired,
      'currentVersion': currentVersion,
      'latestVersion': latestVersion,
      'updateUrl': updateUrl,
    };
  }
}
