import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/presentation/bindings/home_screen_binding.dart';
import 'package:kacamatamoo/presentation/bindings/splash_screen_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/home_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/splash_screen.dart';

class AppRoutes {
  static List<GetPage> pages = [
    GetPage(
      name: ScreenRoutes.initialRoute,
      page: () => SplashScreen(),
      bindings: [SplashScreenBinding()],
    ),
    GetPage(
      name: ScreenRoutes.home,
      page: () => HomeScreen(),
      bindings: [HomeScreenBinding()],
    ),
  ];
}
