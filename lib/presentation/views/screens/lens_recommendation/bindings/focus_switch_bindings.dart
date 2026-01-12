import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/lens_recommendation/controller/focus_switch_controller.dart';

class FocusSwitchBindings extends BaseBinding{
  @override
  void handleArguments(){
    Get.lazyPut(() => FocusSwitchController());
  }
}