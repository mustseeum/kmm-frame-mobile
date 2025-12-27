import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/constants/api_constants.dart';
import 'package:kacamatamoo/core/network/network_info.dart';
import 'package:kacamatamoo/data/cache/cache_manager.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Cache
    // Get.put(CacheManager(), permanent: true);

    // API client
    Get.put(ApiConstants(), permanent: true);

    // Network info
    Connectivity connectivity = Connectivity();
    Get.put(NetworkInfo(connectivity), permanent: true);

    // Tambahkan LoginBl atau Auth Controller
    // Get.put(LoginBl(), permanent: true);
  }
}