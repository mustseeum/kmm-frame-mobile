// lib/localization/localization_service.dart
import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kacamatamoo/localization/en_us.dart';
import 'package:kacamatamoo/localization/id_id.dart';

class LocalizationService extends Translations {
  static const String _storageKey = 'selected_language';
  static final _storage = GetStorage();
  
  // Supported locales
  static const localeEN = Locale('en', 'US');
  static const localeID = Locale('id', 'ID');
  
  // Default locale is English
  static final fallbackLocale = localeEN;
  
  // Get current locale from storage or use default (English)
  static Locale get locale {
    final savedLanguage = _storage.read(_storageKey);
    if (savedLanguage == 'id_ID') {
      return localeID;
    }
    // Default to English
    return localeEN;
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'id_ID': idID,
      };
  
  // Change language and persist the choice
  static Future<void> changeLocale(String languageCode) async {
    Locale newLocale;
    if (languageCode == 'id' || languageCode == 'id_ID') {
      newLocale = localeID;
      await _storage.write(_storageKey, 'id_ID');
    } else {
      newLocale = localeEN;
      await _storage.write(_storageKey, 'en_US');
    }
    await Get.updateLocale(newLocale);
  }
  
  // Get current language code
  static String getCurrentLanguage() {
    final savedLanguage = _storage.read(_storageKey);
    return savedLanguage ?? 'en_US';
  }
  
  // Check if current language is English
  static bool isEnglish() {
    return getCurrentLanguage() == 'en_US';
  }
  
  // Check if current language is Indonesian
  static bool isIndonesian() {
    return getCurrentLanguage() == 'id_ID';
  }
}