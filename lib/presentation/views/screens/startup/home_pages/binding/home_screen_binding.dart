import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/home_pages/controller/home_screen_controller.dart';

class HomeScreenBinding extends BaseBinding {
  // @override
  // void dependencies() {
  //   Get.lazyPut(() => HomeScreenController());
  // }
  @override
  void handleArguments() {
    Get.lazyPut(() => HomeScreenController());
  }
}
