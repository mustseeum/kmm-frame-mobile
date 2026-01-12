import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:kacamatamoo/core/utils/navigation_helper.dart';
import 'package:kacamatamoo/core/utils/permission_helper.dart';
import 'package:kacamatamoo/localization/localization_service.dart';

enum Language { id, en }

class HomeScreenController extends BaseController {
  final Rx<Language> language = Language.en.obs;

  // Use .tr for all text to support dynamic language switching
  // Keep language.value reference so Obx can track changes
  String titleWhenAI() {
    // Reference observable to trigger Obx updates
    language.value;
    return 'ai_help_your_style'.tr;
  }
  
  String optionFrameTitle() {
    language.value;
    return 'title_menu_one'.tr;
  }
  
  String optionLensTitle() {
    language.value;
    return 'title_menu_two'.tr;
  }
  
  String optionBothTitle() {
    language.value;
    return 'title_menu_three'.tr;
  }
  
  String lorem() => 'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum';

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
    _requestInitialPermissions();
  }
  
  /// Load the saved language preference
  void _loadSavedLanguage() {
    final currentLang = LocalizationService.getCurrentLanguage();
    if (currentLang == 'id_ID') {
      language.value = Language.id;
    } else {
      language.value = Language.en;
    }
  }

  /// Request camera, storage, microphone, and audio permissions on initialization
  Future<void> _requestInitialPermissions() async {
    final cameraStorageResult = await PermissionHelper.requestCameraAndStoragePermissions();
    final audioMicResult = await PermissionHelper.requestMicrophoneAndAudioPermissions();

    final cameraGranted = cameraStorageResult['camera'] ?? false;
    final storageGranted = cameraStorageResult['storage'] ?? false;
    final microphoneGranted = audioMicResult['microphone'] ?? false;
    final audioGranted = audioMicResult['audio'] ?? false;

    final denied = <String>[];
    if (!cameraGranted) denied.add('Camera');
    if (!storageGranted) denied.add('Storage');
    if (!microphoneGranted) denied.add('Microphone');
    if (!audioGranted) denied.add('Audio');

    if (denied.isNotEmpty) {
      Get.snackbar(
        'Permissions Required',
        '${denied.join(', ')} access is needed for AR try-on feature',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        mainButton: TextButton(
          onPressed: () => PermissionHelper.openAppSettings(),
          child: const Text('Open Settings'),
        ),
      );
    }
  }

  /// Change language and persist the choice
  void toggleLanguage(Language lang) async {
    language.value = lang;
    
    // Persist language choice and update app locale
    if (lang == Language.id) {
      await LocalizationService.changeLocale('id_ID');
    } else {
      await LocalizationService.changeLocale('en_US');
    }
    
    // Refresh the UI to reflect language change
    update();
  }

  void onTapOption(String key) {
    // Replace with real navigation
    if (key == 'frame') {
      Navigation.navigateToWithArguments(ScreenRoutes.privacyIntroScreen, arguments: {'source': 'frame'});
      // Get.snackbar('Selected', key, snackPosition: SnackPosition.BOTTOM);
    } else if (key == 'lens') {
      Navigation.navigateToWithArguments(ScreenRoutes.privacyIntroScreen, arguments: {'source': 'lens'});
      // Get.snackbar('Selected', key, snackPosition: SnackPosition.BOTTOM);
    } else if (key == 'both') {
      Navigation.navigateTo(ScreenRoutes.tryOnGlasses);
      // Get.snackbar('Selected', key, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void goBack() {
    Get.back();
  }
  
  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // TODO: implement handleArguments
  }
}
