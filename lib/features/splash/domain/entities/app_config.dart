class AppConfig {
  final bool isFirstLaunch;
  final bool isUpdateRequired;
  final String currentVersion;
  final String? latestVersion;
  final String? updateUrl;

  const AppConfig({
    required this.isFirstLaunch,
    required this.isUpdateRequired,
    required this.currentVersion,
    this.latestVersion,
    this.updateUrl,
  });

  AppConfig copyWith({
    bool? isFirstLaunch,
    bool? isUpdateRequired,
    String? currentVersion,
    String? latestVersion,
    String? updateUrl,
  }) {
    return AppConfig(
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      isUpdateRequired: isUpdateRequired ?? this.isUpdateRequired,
      currentVersion: currentVersion ?? this.currentVersion,
      latestVersion: latestVersion ?? this.latestVersion,
      updateUrl: updateUrl ?? this.updateUrl,
    );
  }
}
