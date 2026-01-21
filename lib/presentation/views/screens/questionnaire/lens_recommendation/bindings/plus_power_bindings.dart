import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/controller/plus_power_controller.dart';

class PlusPowerBindings extends BaseBinding{
  @override
  void handleArguments(){
    Get.lazyPut(() => PlusPowerController());
  }
}