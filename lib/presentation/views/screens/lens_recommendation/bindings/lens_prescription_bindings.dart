import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/lens_recommendation/controller/lens_prescription_controller.dart';

class LensPrescriptionBindings extends BaseBinding{
  @override
  void handleArguments(){
    Get.lazyPut(() => LensPrescriptionController());
  }
}