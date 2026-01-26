import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/scanning_face/controllers/scan_face_controller.dart';

class ScanBinding extends BaseBinding {
  @override
  void handleArguments() {
    Get.lazyPut<ScanFaceController>(() => ScanFaceController());
  }
}