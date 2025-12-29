import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/presentation/bindings/try_on_glasses_screen_binding.dart';
import 'package:kacamatamoo/presentation/bindings/splash_screen_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/try_on_glasses_screen.dart';
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
      page: () => TryOnGlassesScreen(),
      bindings: [TryOnGlassesScreenBinding()],
    ),
  ];
}
