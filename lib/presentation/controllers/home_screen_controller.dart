import 'package:get/get.dart';

enum Language { id, en }

class HomeScreenController extends GetxController {
  final Rx<Language> language = Language.en.obs;

  // Example localized strings (small demo). Replace with real localization if needed.
  String titleWhenAI() => language.value == Language.en ? 'ai_help_your_style'.tr : 'Saat AI membantu gayamu';
  String optionFrameTitle() => language.value == Language.en ? 'title_menu_one'.tr : 'Saya ingin frame baru';
  String optionLensTitle() => language.value == Language.en ? 'title_menu_two'.tr : 'Saya ingin lensa baru';
  String optionBothTitle() => language.value == Language.en ? 'title_menu_three'.tr : 'Saya ingin keduanya';
  String lorem() => language.value == Language.en ? 'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum' : 'Contoh deskripsi singkat';

  void toggleLanguage(Language lang) {
    language.value = lang;
  }

  void onTapOption(String key) {
    // Replace with real navigation
    Get.snackbar('Selected', key, snackPosition: SnackPosition.BOTTOM);
  }

  void goBack() {
    Get.back();
  }
}