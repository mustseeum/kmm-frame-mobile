import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kacamatamoo/core/constants/constants.dart';

enum PreferenceKey { sample, userDM }

mixin CacheManager {
  // sample to set data to shared preference
  Future<bool> setSample(String data) async {
    try {
      final storage = GetStorage();
      storage.write(PreferenceKey.sample.name, data);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // sample to get data from preference
  Future<String> getSample() async {
    try {
      final storage = GetStorage();
      if (storage.hasData(PreferenceKey.sample.name)) {
        String data = storage.read(PreferenceKey.sample.name);
        return data;
      } else {
        return "";
      }
    } catch (e) {
      debugPrint(e.toString());
      return "";
    }
  }

  String? getSelectedEnvironment() {
    final storage = GetStorage();
    String coreEnvType = storage.hasData(CacheManagerKey.environmentType.name)
        ? storage.read(CacheManagerKey.environmentType.name)
        : EnvironmentType.dev.name;
    return coreEnvType;
  }
}
