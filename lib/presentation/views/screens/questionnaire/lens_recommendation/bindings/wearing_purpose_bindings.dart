import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/controller/wearing_purpose_controller.dart';

class WearingPurposeBindings extends BaseBinding {
  @override
  void handleArguments() {
    Get.lazyPut(() => WearingPurposeController());
  }
  
}