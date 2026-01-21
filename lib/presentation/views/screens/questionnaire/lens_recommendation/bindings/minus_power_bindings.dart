import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/controller/minus_power_controller.dart';

class MinusPowerBindings extends BaseBinding{
  @override
  void handleArguments(){
    Get.lazyPut(() => MinusPowerController());
  }
}