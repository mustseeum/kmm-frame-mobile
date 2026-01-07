import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/scanning_face/scan_face_controller.dart';

class ScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanFaceController>(() => ScanFaceController());
  }
}