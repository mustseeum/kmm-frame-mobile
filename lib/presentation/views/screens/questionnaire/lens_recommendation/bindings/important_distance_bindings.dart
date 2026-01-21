import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/controller/important_distance_controller.dart';

class ImportantDistanceBindings extends BaseBinding{
  @override
  void handleArguments(){
    Get.lazyPut(() => ImportantDistanceController());
  }
}