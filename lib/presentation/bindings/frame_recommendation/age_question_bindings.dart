import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/frame_recommendation/age_controller.dart';

class AgeQuestionBindings extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => AgeController());
  }
}