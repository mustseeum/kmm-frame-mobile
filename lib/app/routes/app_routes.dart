import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/bindings/age_question_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/virtual_try_on/bindings/try_on_glasses_screen_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/scan_result.dart/bindings/scan_result_bindings.dart';
import 'package:kacamatamoo/presentation/bindings/startup/login_binding.dart';
import 'package:kacamatamoo/presentation/bindings/startup/home_screen_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/bindings/privacy_intro_binding.dart';
import 'package:kacamatamoo/presentation/bindings/startup/sync_information_screen_binding.dart';
import 'package:kacamatamoo/presentation/bindings/startup/splash_screen_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/bindings/wear_question_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/scan_result.dart/pages/scan_result_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/scanning_face/bindings/scan_face_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/scanning_face/pages/scan_face_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/pages/privacy_intro_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/pages/age_question_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/pages/wear_purpose_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/pages/home_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/pages/login_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/pages/splash_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/pages/sync_information_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/virtual_try_on/pages/virtual_try_on_screen.dart';

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
      page: () => VirtualTryOnPage(),
      bindings: [VirtualTryOnPageBinding()],
    ),
    // GetPage(
    //   name: ScreenRoutes.tryOnGlasses,
    //   page: () => TryOnGlassesScreen(),
    //   bindings: [TryOnGlassesScreenBinding()],
    // ),
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
    GetPage(
      name: ScreenRoutes.scanResultScreen,
      page: () =>  ScanResultScreen(),
      bindings: [ScanResultBinding()],
    ),
  ];
}
