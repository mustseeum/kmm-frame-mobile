import 'package:kacamatamoo/core/constants/constants.dart';
import 'package:kacamatamoo/localization/localization_service.dart';

/// Helper class for language-related operations
class LanguageHelper {
  /// Loads the currently saved language preference
  static Language loadSavedLanguage() {
    final currentLang = LocalizationService.getCurrentLanguage();
    return currentLang == 'id_ID' ? Language.id : Language.en;
  }

  /// Changes the app language and persists the choice
  static Future<void> changeLanguage(Language language) async {
    if (language == Language.id) {
      await LocalizationService.changeLocale('id_ID');
    } else {
      await LocalizationService.changeLocale('en_US');
    }
  }

  /// Gets the language code (for API requests or logging)
  static String getLanguageCode(Language language) {
    return language == Language.id ? 'id' : 'en';
  }

  /// Gets the locale string for the given language
  static String getLocaleString(Language language) {
    return language == Language.id ? 'id_ID' : 'en_US';
  }
}
