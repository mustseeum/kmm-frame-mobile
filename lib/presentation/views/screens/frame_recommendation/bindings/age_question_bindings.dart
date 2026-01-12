import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/controller/age_controller.dart';

class AgeQuestionBindings extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => AgeController());
  }
}