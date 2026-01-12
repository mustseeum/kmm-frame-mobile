import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/controllers/splash_screen_controller.dart';

class SplashScreenBinding extends BaseBinding{
  @override
  void handleArguments(){
    Get.lazyPut(() => SplashScreenController());
  }
}