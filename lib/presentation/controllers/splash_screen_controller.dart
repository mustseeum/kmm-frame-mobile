import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';

class SplashScreenController extends GetxController {
  SplashScreenController();

  @override
  void onReady() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      Get.offNamed(ScreenRoutes.home);
    });
  }
}
