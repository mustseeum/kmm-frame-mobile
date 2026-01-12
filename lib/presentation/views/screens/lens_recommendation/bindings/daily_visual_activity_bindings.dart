import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/lens_recommendation/controller/daily_visual_activity_controller.dart';

class DailyVisualActivityBindings extends BaseBinding{
  @override
  void handleArguments(){
    Get.lazyPut(() => DailyVisualActivityController());
  }
}