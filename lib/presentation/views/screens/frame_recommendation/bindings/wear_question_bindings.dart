import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/controller/wear_purpose_controller.dart';

class WearQuestionBindings extends BaseBinding{
  @override
  void handleArguments(){
    Get.lazyPut(() => WearPurposeController());
  }
}