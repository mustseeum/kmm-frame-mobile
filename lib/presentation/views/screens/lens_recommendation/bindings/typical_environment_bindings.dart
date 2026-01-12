import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/lens_recommendation/controller/typical_environment_controller.dart';

class TypicalEnvironmentBindings extends BaseBinding{
  @override
  void handleArguments(){
    Get.lazyPut(() => TypicalEnvironmentController());
  }
}