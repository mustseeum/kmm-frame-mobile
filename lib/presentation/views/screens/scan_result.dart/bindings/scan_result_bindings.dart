import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/scan_result.dart/controllers/scan_result_controller.dart';

class ScanResultBinding extends BaseBinding {
  @override
  void handleArguments() {
    Get.lazyPut<ScanResultController>(() => ScanResultController());
  }
}