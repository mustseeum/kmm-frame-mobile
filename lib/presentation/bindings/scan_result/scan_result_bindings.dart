import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/scan_result/scan_result_controller.dart';

class ScanResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanResultController>(() => ScanResultController());
  }
}