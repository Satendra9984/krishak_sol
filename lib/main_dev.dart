import 'package:bhoomi_sakti/app/config/flavors/flavor_config.dart';
import 'package:bhoomi_sakti/main_common.dart';

void main() {
  FlavorConfig.initialize(
    flavor: Flavor.dev,
    appName: "Bhoomi Shakti Dev",
    // apiBaseUrl: "https://dev-api.bhoomishakti.com/v1", // Example DEV API URL
    apiBaseUrl: "http://35.244.11.78:9101/api",
  );
  mainCommon(FlavorConfig.instance);
}
