import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/utils/permission_helper.dart';

enum Language { id, en }

class HomeScreenController extends GetxController {
  final Rx<Language> language = Language.en.obs;

  // Example localized strings (small demo). Replace with real localization if needed.
  String titleWhenAI() => language.value == Language.en
      ? 'ai_help_your_style'.tr
      : 'Saat AI membantu gayamu';
  String optionFrameTitle() => language.value == Language.en
      ? 'title_menu_one'.tr
      : 'Saya ingin frame baru';
  String optionLensTitle() => language.value == Language.en
      ? 'title_menu_two'.tr
      : 'Saya ingin lensa baru';
  String optionBothTitle() => language.value == Language.en
      ? 'title_menu_three'.tr
      : 'Saya ingin keduanya';
  String lorem() => language.value == Language.en
      ? 'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum'
      : 'Contoh deskripsi singkat';

  @override
  void onInit() {
    super.onInit();
    _requestInitialPermissions();
  }

  /// Request camera and storage permissions on initialization
  Future<void> _requestInitialPermissions() async {
    final result = await PermissionHelper.requestCameraAndStoragePermissions();

    final cameraGranted = result['camera'] ?? false;
    final storageGranted = result['storage'] ?? false;

    if (!cameraGranted || !storageGranted) {
      final denied = <String>[];
      if (!cameraGranted) denied.add('Camera');
      if (!storageGranted) denied.add('Storage');

      Get.snackbar(
        'Permissions Required',
        '${denied.join(' and ')} access is needed for AR try-on feature',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        mainButton: TextButton(
          onPressed: () => PermissionHelper.openAppSettings(),
          child: const Text('Open Settings'),
        ),
      );
    }
  }

  void toggleLanguage(Language lang) {
    language.value = lang;
  }

  void onTapOption(String key) {
    // Replace with real navigation
    if (key == 'frame') {
      Get.toNamed(ScreenRoutes.ageQuestionScreen);
      Get.snackbar('Selected', key, snackPosition: SnackPosition.BOTTOM);
    } else if (key == 'lens') {
      Get.toNamed(ScreenRoutes.exampleTryOnGlasses);
      Get.snackbar('Selected', key, snackPosition: SnackPosition.BOTTOM);
    } else if (key == 'both') {
      Get.snackbar('Selected', key, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void goBack() {
    Get.back();
  }
}
