import 'package:kacamatamoo/core/constants/constants.dart';
import 'package:kacamatamoo/data/cache/cache_manager.dart';

class AppEnvironment with CacheManager {
  String API_URL_PROD = "";
  static const String API_VERSION = "v1";
  String API_URL_STAG = "";
  String API_URL_DEV = "";

  // selected environtment
  EnvironmentType environtment = EnvironmentType.dev;

  baseUrl() {
    String? env = getSelectedEnvironment();
    if (env == EnvironmentType.dev.name) {
      return API_URL_DEV;
    } else if (env == EnvironmentType.prod.name ||
        env == EnvironmentType.prod.name) {
      return API_URL_PROD;
    } else {
      return API_URL_DEV;
    }
  }
}
