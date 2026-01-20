import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kacamatamoo/core/constants/constants.dart';
import 'package:kacamatamoo/core/utilities/function_helper.dart';
import 'package:kacamatamoo/data/models/data_response/login/login_data_model.dart';
import 'package:kacamatamoo/data/models/data_response/session/session_dm.dart';

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
  Future<bool> saveUserData(LoginDataModel userData) async {
    try {
      final storage = GetStorage();
      final json = jsonEncode(userData.toJson());
      final encrypt = FunctionHelper.aesEncrypt(json, aesKey);
      await storage.write(CacheManagerKey.userData.name, encrypt);
      return true;
    } catch (e) {
      debugPrint('Error saving user data: ${e.toString()}');
      return false;
    }
  }

  // Get user data
  Future<LoginDataModel> getUserData() async {
    final storage = GetStorage();
    if (storage.hasData(CacheManagerKey.userData.name)) {
      final data = storage.read(CacheManagerKey.userData.name);
      final decrypt = FunctionHelper.aesDecrypt(data, aesKey);
      final json = jsonDecode(decrypt);
      return LoginDataModel.fromJson(json);
    } else {
      return LoginDataModel();
    }
  }

  // Save user data (as JSON string or Map)
  Future<bool> saveSessionData(SessionDm sessionData) async {
    try {
      final storage = GetStorage();
      final json = jsonEncode(sessionData.toJson());
      final encrypt = FunctionHelper.aesEncrypt(json, aesKey);
      await storage.write(CacheManagerKey.sessionData.name, encrypt);
      return true;
    } catch (e) {
      debugPrint('Error saving session data: ${e.toString()}');
      return false;
    }
  }

  // Get session data
  Future<SessionDm> getSessionData() async {
    final storage = GetStorage();
    if (storage.hasData(CacheManagerKey.sessionData.name)) {
      final data = storage.read(CacheManagerKey.sessionData.name);
      final decrypt = FunctionHelper.aesDecrypt(data, aesKey);
      final json = jsonDecode(decrypt);
      return SessionDm.fromJson(json);
    } else {
      return SessionDm();
    }
  }

  Future<bool> clearSessionData() async {
    try {
      final storage = GetStorage();
      await storage.remove(CacheManagerKey.sessionData.name);
      return true;
    } catch (e) {
      debugPrint('Error clearing auth data: ${e.toString()}');
      return false;
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
      await storage.remove(CacheManagerKey.sessionData.name);
      return true;
    } catch (e) {
      debugPrint('Error clearing auth data: ${e.toString()}');
      return false;
    }
  }
}
