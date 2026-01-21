import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/controller/digital_eye_fatigue_controller.dart';

class DigitalEyeFatigueBindings extends BaseBinding{
  @override
  void handleArguments(){
    Get.lazyPut(() => DigitalEyeFatigueController());
  }
}