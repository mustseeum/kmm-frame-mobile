import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/controller/budget_preference_controller.dart';

class BudgetPreferenceBindings extends BaseBinding {
  @override
  void handleArguments() {
    // No controller to bind for this screen
    Get.lazyPut(() => BudgetPreferenceController());
  }
}
