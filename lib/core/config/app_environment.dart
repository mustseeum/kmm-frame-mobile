import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kacamatamoo/core/constants/constants.dart';
import 'package:kacamatamoo/data/cache/cache_manager.dart';

class AppEnvironment with CacheManager {
  static const String API_VERSION = "/v1/";
  String API_URL_PROD = "${dotenv.env['BASE_URL_PROD']}$API_VERSION";
  String API_URL_DEV = "${dotenv.env['BASE_URL_DEV']}$API_VERSION";

  // selected environtment
  EnvironmentType environtment = EnvironmentType.dev;

  baseUrl() {
    String? env = getSelectedEnvironment();
    if (env == EnvironmentType.prod.name) {
      return API_URL_PROD;
    } else {
      return API_URL_DEV;
    }
  }
}
