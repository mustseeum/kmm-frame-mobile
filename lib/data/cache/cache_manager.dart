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

  // Save authentication token
  Future<bool> saveAuthToken(String token) async {
    try {
      final storage = GetStorage();
      await storage.write(CacheManagerKey.authToken.name, token);
      return true;
    } catch (e) {
      debugPrint('Error saving auth token: ${e.toString()}');
      return false;
    }
  }

  // Get authentication token
  String? getAuthToken() {
    try {
      final storage = GetStorage();
      if (storage.hasData(CacheManagerKey.authToken.name)) {
        return storage.read(CacheManagerKey.authToken.name);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting auth token: ${e.toString()}');
      return null;
    }
  }

  // Save user data (as JSON string or Map)
  Future<bool> saveUserData(dynamic userData) async {
    try {
      final storage = GetStorage();
      await storage.write(CacheManagerKey.userData.name, userData);
      return true;
    } catch (e) {
      debugPrint('Error saving user data: ${e.toString()}');
      return false;
    }
  }

  // Get user data
  dynamic getUserData() {
    try {
      final storage = GetStorage();
      if (storage.hasData(CacheManagerKey.userData.name)) {
        return storage.read(CacheManagerKey.userData.name);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user data: ${e.toString()}');
      return null;
    }
  }

  // Save login status
  Future<bool> saveLoginStatus(bool isLoggedIn) async {
    try {
      final storage = GetStorage();
      await storage.write(CacheManagerKey.isLoggedIn.name, isLoggedIn);
      return true;
    } catch (e) {
      debugPrint('Error saving login status: ${e.toString()}');
      return false;
    }
  }

  // Check if user is logged in
  bool isUserLoggedIn() {
    try {
      final storage = GetStorage();
      if (storage.hasData(CacheManagerKey.isLoggedIn.name)) {
        return storage.read(CacheManagerKey.isLoggedIn.name) ?? false;
      }
      return false;
    } catch (e) {
      debugPrint('Error checking login status: ${e.toString()}');
      return false;
    }
  }

  // Clear all authentication data (for logout)
  Future<bool> clearAuthData() async {
    try {
      final storage = GetStorage();
      await storage.remove(CacheManagerKey.authToken.name);
      await storage.remove(CacheManagerKey.userData.name);
      await storage.remove(CacheManagerKey.isLoggedIn.name);
      return true;
    } catch (e) {
      debugPrint('Error clearing auth data: ${e.toString()}');
      return false;
    }
  }
}
