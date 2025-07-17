import 'package:bhoomi_sakti/app/config/flavors/flavor_config.dart';
import 'package:bhoomi_sakti/main_common.dart';

void main() {
  FlavorConfig.initialize(
    flavor: Flavor.prod,
    appName: "Bhoomi Shakti",
    apiBaseUrl: "https://api.bhoomishakti.com/v1", // Example PROD API URL
  );
  mainCommon(FlavorConfig.instance);
}
