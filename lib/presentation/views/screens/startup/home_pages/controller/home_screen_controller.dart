import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:kacamatamoo/core/constants/constants.dart';
import 'package:kacamatamoo/core/utilities/language_helper.dart';
import 'package:kacamatamoo/core/utilities/navigation_helper.dart';
import 'package:kacamatamoo/core/utilities/permission_helper.dart';
import 'package:kacamatamoo/core/utilities/session_helper.dart';

class HomeScreenController extends BaseController {
  final Rx<Language> language = Language.en.obs;
  final SessionHelper _sessionHelper = SessionHelper();
  final RxBool isLoading = false.obs;

  // Text getters for UI with language tracking
  String get titleWhenAI {
    language.value; // Track language changes
    return 'ai_help_your_style'.tr;
  }

  String get optionFrameTitle {
    language.value;
    return 'title_menu_one'.tr;
  }

  String get optionLensTitle {
    language.value;
    return 'title_menu_two'.tr;
  }

  String get optionBothTitle {
    language.value;
    return 'title_menu_three'.tr;
  }

  String get lorem {
    language.value;
    return 'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum';
  }

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
    _requestInitialPermissions();
  }

  /// Load the saved language preference
  void _loadSavedLanguage() {
    language.value = LanguageHelper.loadSavedLanguage();
  }

  /// Request camera, storage, microphone, and audio permissions on initialization
  Future<void> _requestInitialPermissions() async {
    final cameraStorageResult =
        await PermissionHelper.requestCameraAndStoragePermissions();
    // final audioMicResult =
    //     await PermissionHelper.requestMicrophoneAndAudioPermissions();

    final cameraGranted = cameraStorageResult['camera'] ?? false;
    final storageGranted = cameraStorageResult['storage'] ?? false;
    // final microphoneGranted = audioMicResult['microphone'] ?? false;
    // final audioGranted = audioMicResult['audio'] ?? false;

    final denied = <String>[];
    if (!cameraGranted) denied.add('Camera');
    if (!storageGranted) denied.add('Storage');
    // if (!microphoneGranted) denied.add('Microphone');
    // if (!audioGranted) denied.add('Audio');

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
  Future<void> toggleLanguage(Language lang) async {
    language.value = lang;
    await LanguageHelper.changeLanguage(lang);
    update();
  }

  /// Handle option selection and start session
  Future<void> onTapOption(String key) async {
    try {
      isLoading.value = true;
      final lang = Get.locale?.languageCode ?? 'en';
      await _sessionHelper.getSessionProductAndNavigate(key, lang);
    } catch (e) {
      debugPrint('Error in onTapOption: $e');
      Get.snackbar(
        'Error',
        'Failed to start session. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle back navigation - only allow going back to SyncInformationScreen
  void handleBackNavigation() {
    Navigation.navigateAndRemoveAll(ScreenRoutes.syncScreen);
  }

  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // TODO: implement handleArguments
  }
}
