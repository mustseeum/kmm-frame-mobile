import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/views/screens/scan_result.dart/controllers/scan_result_controller.dart';

class ScanResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanResultController>(() => ScanResultController());
  }
}