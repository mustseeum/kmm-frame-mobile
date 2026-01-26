import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/frame_recommendation/bindings/question_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/frame_recommendation/bindings/wear_purpose_question_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/bindings/astigmatism_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/bindings/budget_preference_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/bindings/impact_resistance_importance_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/bindings/light_sensitivity_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/bindings/plus_power_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/bindings/important_distance_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/bindings/minus_power_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/bindings/digital_eye_fatigue_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/bindings/uv_protection_importance_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/bindings/wearing_purpose_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/pages/astigmatism_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/pages/budget_preference_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/pages/impact_resistance_importance_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/pages/light_sensitivity_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/pages/plus_power_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/pages/digital_eye_fatigue_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/pages/minus_power_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/pages/important_distance_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/pages/uv_protection_importance_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/lens_recommendation/pages/wearing_purpose_screens.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/store_information_pages/page/sync_information_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/scan_result.dart/bindings/scan_result_bindings.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/login_pages/binding/login_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/home_pages/binding/home_screen_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/privacy_policies/binding/privacy_intro_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/store_information_pages/binding/sync_information_screen_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/splash_screen_pages/binding/splash_screen_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/scan_result.dart/pages/scan_result_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/scanning_face/bindings/scan_face_binding.dart';
import 'package:kacamatamoo/presentation/views/screens/scanning_face/pages/scan_face_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/privacy_policies/page/privacy_intro_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/frame_recommendation/pages/question_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/questionnaire/frame_recommendation/pages/wear_purpose_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/home_pages/page/home_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/login_pages/page/login_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/splash_screen_pages/page/splash_screen.dart';
import 'package:kacamatamoo/presentation/views/screens/virtual_try_on/bindings/try_on_glasses_screen_v2_binding.dart';
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
      name: ScreenRoutes.minusPowerScreen,
      page: () => MinusPowerScreen(),
      bindings: [MinusPowerBindings()],
    ),
    GetPage(
      name: ScreenRoutes.plusPowerScreen,
      page: () => PlusPowerScreen(),
      bindings: [PlusPowerBindings()],
    ),
    GetPage(
      name: ScreenRoutes.astigmatismScreen,
      page: () => AstigmatismScreen(),
      bindings: [AstigmatismBindings()],
    ),
    GetPage(
      name: ScreenRoutes.wearingPurposeScreen,
      page: () => WearingPurposeScreens(),
      bindings: [WearingPurposeBindings()],
    ),
    GetPage(
      name: ScreenRoutes.importantDistanceScreen,
      page: () => ImportantDistanceScreen(),
      bindings: [ImportantDistanceBindings()],
    ),
    GetPage(
      name: ScreenRoutes.digitalEyeFatigueScreen,
      page: () => DigitalEyeFatigueScreen(),
      bindings: [DigitalEyeFatigueBindings()],
    ),
    GetPage(
      name: ScreenRoutes.uvProtectionImportanceScreen,
      page: () => UvProtectionImportanceScreen(),
      bindings: [UvProtectionImportanceBindings()],
    ),
    GetPage(
      name: ScreenRoutes.lightSensitivityScreen,
      page: () => LightSensitivityScreen(),
      bindings: [LightSensitivityBindings()],
    ),
    GetPage(
      name: ScreenRoutes.impactResistanceImportanceScreen,
      page: () => ImpactResistanceImportanceScreen(),
      bindings: [ImpactResistanceImportanceBindings()],
    ),
    GetPage(
      name: ScreenRoutes.budgetPreferenceScreen,
      page: () => BudgetPreferenceScreen(),
      bindings: [BudgetPreferenceBindings()],
    ),
  ];
}
