import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/privacy_policies/controller/privacy_intro_controller.dart';

class PrivacyIntroBinding extends BaseBinding {
  @override
  void handleArguments() {
    // Lazy put the controller so it's created only when needed
    Get.lazyPut<PrivacyIntroController>(() => PrivacyIntroController());
  }
}