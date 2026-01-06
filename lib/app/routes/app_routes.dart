import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/presentation/bindings/age_question_bindings.dart';
import 'package:kacamatamoo/presentation/bindings/example_try_on_glasses_screen_binding.dart';
import 'package:kacamatamoo/presentation/bindings/login_binding.dart';
import 'package:kacamatamoo/presentation/bindings/home_screen_binding.dart';
import 'package:kacamatamoo/presentation/bindings/privacy_intro_binding.dart';
import 'package:kacamatamoo/presentation/bindings/sync_information_screen_binding.dart';
import 'package:kacamatamoo/presentation/bindings/try_on_glasses_screen_binding.dart';
import 'package:kacamatamoo/presentation/bindings/splash_screen_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/glasses_try_on_example.dart';
import 'package:kacamatamoo/presentation/views/screens/login_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/home_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/privacy_intro_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/age_question_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/sync_information_screen.dart';
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
      name: ScreenRoutes.login,
      page: () => LoginScreen(),
      bindings: [LoginScreenBinding()],
    ),
    GetPage(
      name: ScreenRoutes.syncScreen,
      page: () => SyncInfotmationScreen(),
      bindings: [SyncInformationScreenBinding()],
    ),
    GetPage(
      name: ScreenRoutes.home,
      page: () => HomeScreen(),
      bindings: [HomeScreenBinding()],
    ),
    GetPage(
      name: ScreenRoutes.tryOnGlasses,
      page: () => TryOnGlassesScreen(),
      bindings: [TryOnGlassesScreenBinding()],
    ),
    GetPage(
      name: ScreenRoutes.exampleTryOnGlasses,
      page: () => GlassesTryOnExample(),
      bindings: [ExampleTryOnGlassesScreenBinding()],
    ),
    GetPage(
      name: ScreenRoutes.privacyIntroScreen,
      page: () => PrivacyIntroScreen(),
      bindings: [PrivacyIntroBinding()],
    ),
    GetPage(
      name: ScreenRoutes.ageQuestionScreen,
      page: () =>  AgeQuestionScreen(),
      bindings: [AgeQuestionBindings()],
    ),
  ];
}
