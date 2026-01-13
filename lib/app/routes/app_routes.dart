import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/bindings/question_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/bindings/wear_purpose_question_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/lens_recommendation/bindings/daily_eye_usage_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/lens_recommendation/bindings/daily_visual_activity_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/lens_recommendation/bindings/focus_switch_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/lens_recommendation/bindings/lens_prescription_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/lens_recommendation/bindings/typical_environment_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/lens_recommendation/pages/daily_eye_usage_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/lens_recommendation/pages/daily_visual_activity_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/lens_recommendation/pages/focus_switch_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/lens_recommendation/pages/lens_prescription_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/lens_recommendation/pages/typical_environment_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/pages/sync_information_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/virtual_try_on/bindings/try_on_glasses_screen_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/scan_result.dart/bindings/scan_result_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/bindings/login_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/bindings/home_screen_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/bindings/privacy_intro_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/bindings/sync_information_screen_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/bindings/splash_screen_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/scan_result.dart/pages/scan_result_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/scanning_face/bindings/scan_face_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/scanning_face/pages/scan_face_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/pages/privacy_intro_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/pages/question_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/frame_recommendation/pages/wear_purpose_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/pages/home_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/pages/login_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/pages/splash_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/virtual_try_on/bindings/try_on_glasses_screen_v2_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/virtual_try_on/pages/virtual_try_on_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/virtual_try_on/pages/virtual_try_on_screen_v2.dart';

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
      page: () => SyncInformationScreen(),
      bindings: [SyncInformationScreenBinding()],
    ),
    GetPage(
      name: ScreenRoutes.home,
      page: () => HomeScreen(),
      bindings: [HomeScreenBinding()],
    ),
    GetPage(
      name: ScreenRoutes.tryOnGlasses,
      page: () => VirtualTryOnPageV2(),
      bindings: [VirtualTryOnV2Binding()],
    ),
    GetPage(
      name: ScreenRoutes.privacyIntroScreen,
      page: () => PrivacyIntroScreen(),
      bindings: [PrivacyIntroBinding()],
    ),
    GetPage(
      name: ScreenRoutes.ageQuestionScreen,
      page: () => QuestionScreen(),
      bindings: [QuestionBindings()],
    ),
    GetPage(
      name: ScreenRoutes.wearPurposeScreen,
      page: () => WearPurposeScreen(),
      bindings: [WearPurposeQuestionBindings()],
    ),
    GetPage(
      name: ScreenRoutes.scanningFaceScreen,
      page: () => ScanFaceScreen(),
      bindings: [ScanBinding()],
    ),
    GetPage(
      name: ScreenRoutes.scanResultScreen,
      page: () => ScanResultScreen(),
      bindings: [ScanResultBinding()],
    ),
    GetPage(
      name: ScreenRoutes.lensPrescriptionScreen,
      page: () => LensPrescriptionScreen(),
      bindings: [LensPrescriptionBindings()],
    ),
    GetPage(
      name: ScreenRoutes.dailyVisualActivityScreen,
      page: () => DailyVisualActivityScreen(),
      bindings: [DailyVisualActivityBindings()],
    ),
    GetPage(
      name: ScreenRoutes.dailyeyeusagescreen,
      page: () => DailyEyeUsageScreen(),
      bindings: [DailyEyeUsageBindings()],
    ),
    GetPage(
      name: ScreenRoutes.focusSwitchScreen,
      page: () => FocusSwitchScreen(),
      bindings: [FocusSwitchBindings()],
    ),
    GetPage(
      name: ScreenRoutes.typicalEnvironmentScreen,
      page: () => TypicalEnvironmentScreen(),
      bindings: [TypicalEnvironmentBindings()],
    ),
  ];
}
