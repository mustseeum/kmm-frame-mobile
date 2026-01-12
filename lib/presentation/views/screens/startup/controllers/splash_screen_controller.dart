import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:kacamatamoo/core/utils/navigation_helper.dart';

class SplashScreenController extends BaseController {
  SplashScreenController();

  @override
  void onReady() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      Navigation.navigateAndReplace(ScreenRoutes.login);
    });
  }
  
  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // TODO: implement handleArguments
  }
}
