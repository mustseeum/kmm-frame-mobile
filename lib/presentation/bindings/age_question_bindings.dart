import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/age_controller.dart';

class AgeQuestionBindings extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => AgeController());
  }
}