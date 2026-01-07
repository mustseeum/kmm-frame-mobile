import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/startup/splash_screen_controller.dart';

class SplashScreenBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => SplashScreenController());
  }
}