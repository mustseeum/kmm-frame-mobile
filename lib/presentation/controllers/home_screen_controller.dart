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

  void toggleLanguage(Language lang) {
    language.value = lang;
  }

  /// Request camera and storage permissions
  Future<bool> requestCameraAndStoragePermissions() async {
    final result = await PermissionHelper.requestCameraAndStoragePermissions();

    final cameraGranted = result['camera'] ?? false;
    final storageGranted = result['storage'] ?? false;

    if (cameraGranted && storageGranted) {
      Get.snackbar(
        'Permissions Granted',
        'Camera and storage access granted',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } else {
      final denied = <String>[];
      if (!cameraGranted) denied.add('Camera');
      if (!storageGranted) denied.add('Storage');

      Get.snackbar(
        'Permissions Required',
        '${denied.join(' and ')} access is needed for this feature',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        mainButton: TextButton(
          onPressed: () => PermissionHelper.openAppSettings(),
          child: const Text('Settings'),
        ),
      );
      return false;
    }
  }

  void onTapOption(String key) async {
    // Replace with real navigation
    if (key == "frame") {
      // Request camera and storage permissions before navigating to try-on
      final hasPermissions = await requestCameraAndStoragePermissions();
      if (hasPermissions) {
        Get.toNamed(ScreenRoutes.exampleTryOnGlasses);
      }
    } else if (key == "lens") {
      Get.snackbar('Selected', key, snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Selected', key, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void goBack() {
    Get.back();
  }
}
