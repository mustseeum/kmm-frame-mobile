
import 'package:kacamatamoo/core/constants/constants.dart';
import 'package:kacamatamoo/data/cache/cache_manager.dart';

class LoggerUtility with CacheManager {
  Future<bool> getChuckerShowStatus() async {
    bool status = await getLoggingActiveStatus();

    if (status) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getChuckerReleaseStatus() async {
    bool status = await getLoggingActiveStatus();

    String? env = getSelectedEnvironment();
    if (env == EnvironmentType.prod.name) {
      return false;
    } else {
      if (status) {
        return true;
      } else {
        return false;
      }
    }
  }
}
