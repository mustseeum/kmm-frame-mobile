import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/views/screens/scanning_face/controllers/scan_face_controller.dart';

class ScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanFaceController>(() => ScanFaceController());
  }
}