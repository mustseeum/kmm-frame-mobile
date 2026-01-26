import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/controller/light_sensitivity_controller.dart';

class LightSensitivityBindings extends BaseBinding {
  @override
  void handleArguments() {
    Get.lazyPut(() => LightSensitivityController());
  }
}