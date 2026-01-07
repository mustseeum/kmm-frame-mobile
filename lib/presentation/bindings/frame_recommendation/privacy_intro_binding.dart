import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/frame_recommendation/privacy_intro_controller.dart';

class PrivacyIntroBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy put the controller so it's created only when needed
    Get.lazyPut<PrivacyIntroController>(() => PrivacyIntroController());
  }
}