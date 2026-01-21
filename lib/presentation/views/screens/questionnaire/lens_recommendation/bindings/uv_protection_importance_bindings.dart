import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/controller/uv_protection_importance_controller.dart';

class UvProtectionImportanceBindings extends BaseBinding {
  @override
  void handleArguments() {
    Get.lazyPut<UvProtectionImportanceController>(
      () => UvProtectionImportanceController(),
    );
  }
  
}