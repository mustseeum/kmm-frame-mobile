import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:kacamatamoo/core/utilities/navigation_helper.dart';
import 'package:kacamatamoo/data/cache/cache_manager.dart';

class SplashScreenController extends BaseController with CacheManager {
  SplashScreenController();

  @override
  void onReady() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      _checkLoginStatus();
    });
  }

  // Check if user is already logged in
  void _checkLoginStatus() {
    final isLoggedIn = isUserLoggedIn();
    final token = getAuthToken();
    final userData = getUserData();

    if (isLoggedIn && token != null) {
      // User is logged in, navigate to home or sync screen
      Navigation.navigateAndReplace(ScreenRoutes.syncScreen);
    } else {
      // User is not logged in, navigate to login screen
      Navigation.navigateAndReplace(ScreenRoutes.login);
    }
  }
  
  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // TODO: implement handleArguments
  }
}
