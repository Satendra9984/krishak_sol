enum Flavor {
  dev,
  prod,
}

class FlavorConfig {
  final Flavor flavor;
  final String appName;
  final String apiBaseUrl;
  // Add other flavor-specific variables here

  static FlavorConfig? _instance;

  FlavorConfig._internal(this.flavor, this.appName, this.apiBaseUrl);

  static FlavorConfig get instance {
    _instance ??= FlavorConfig._internal(
        Flavor.dev, // Default flavor, should be overridden by main_dev/main_prod
        "Bhoomi Shakti Dev",
        "https://dev-api.bhoomishakti.com",
      );
    return _instance!;
  }

  static void initialize({
    required Flavor flavor,
    required String appName,
    required String apiBaseUrl,
  }) {
    _instance = FlavorConfig._internal(flavor, appName, apiBaseUrl);
  }

  bool get isDevelopment => flavor == Flavor.dev;
  bool get isProduction => flavor == Flavor.prod;
}
