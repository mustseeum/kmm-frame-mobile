import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/frame_recommendation/wear_purpose_controller.dart';

class WearQuestionBindings extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => WearPurposeController());
  }
}