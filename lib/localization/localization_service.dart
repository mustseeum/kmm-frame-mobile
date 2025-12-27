// lib/localization/localization_service.dart
import 'dart:ui';

import 'package:get/get.dart';
import 'package:kacamatamoo/localization/en_us.dart';
import 'package:kacamatamoo/localization/id_id.dart';

class LocalizationService extends Translations {
  static Locale get locale => Get.deviceLocale ?? const Locale('id', 'ID');
  static final fallbackLocale = const Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'id_ID': idID,
      };
}