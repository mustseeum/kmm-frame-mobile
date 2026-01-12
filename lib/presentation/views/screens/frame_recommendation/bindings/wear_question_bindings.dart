import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/controller/wear_purpose_controller.dart';

class WearQuestionBindings extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => WearPurposeController());
  }
}