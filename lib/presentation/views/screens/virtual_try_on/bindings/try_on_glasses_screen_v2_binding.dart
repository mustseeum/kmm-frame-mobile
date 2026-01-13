import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/views/screens/virtual_try_on/controllers/try_on_glasses_v2_controller.dart';

class VirtualTryOnV2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VirtualTryOnV2Controller>(() => VirtualTryOnV2Controller());
  }
}