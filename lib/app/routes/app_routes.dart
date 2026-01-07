import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/presentation/bindings/frame_recommendation/age_question_bindings.dart';
import 'package:kacamatamoo/presentation/bindings/frame_recommendation/example_try_on_glasses_screen_binding.dart';
import 'package:kacamatamoo/presentation/bindings/scanning_face/scan_face_binding.dart';
import 'package:kacamatamoo/presentation/bindings/startup/login_binding.dart';
import 'package:kacamatamoo/presentation/bindings/startup/home_screen_binding.dart';
import 'package:kacamatamoo/presentation/bindings/frame_recommendation/privacy_intro_binding.dart';
import 'package:kacamatamoo/presentation/bindings/startup/sync_information_screen_binding.dart';
import 'package:kacamatamoo/presentation/bindings/frame_recommendation/try_on_glasses_screen_binding.dart';
import 'package:kacamatamoo/presentation/bindings/startup/splash_screen_binding.dart';
import 'package:kacamatamoo/presentation/bindings/frame_recommendation/wear_question_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/glasses_try_on_example.dart';
import 'package:kacamatamoo/presentation/views/screens/scanning_face/scan_face_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/login_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/home_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/privacy_intro_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/age_question_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/sync_information_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/try_on_glasses_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/splash_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/wear_purpose_screen.dart';

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
    GetPage(
      name: ScreenRoutes.wearPurposeScreen,
      page: () =>  WearPurposeScreen(),
      bindings: [WearQuestionBindings()],
    ),
    GetPage(
      name: ScreenRoutes.scanningFaceScreen,
      page: () =>  ScanFaceScreen(),
      bindings: [ScanBinding()],
    ),
  ];
}
