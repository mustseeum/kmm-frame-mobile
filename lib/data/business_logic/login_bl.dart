import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/network/dio_module.dart';
import 'package:kacamatamoo/core/network/models/parent_response.dart';
import 'package:kacamatamoo/data/cache/cache_manager.dart';
import 'package:kacamatamoo/data/models/data_response/login/login_data_model.dart';
import 'package:kacamatamoo/data/models/data_response/session/session_dm.dart';
import 'package:kacamatamoo/data/models/request/auth/login_data_request.dart';
import 'package:kacamatamoo/data/models/request/session/session_data_request.dart';
import 'package:kacamatamoo/data/repositories/auth/login_repositories.dart';

class LoginBl with CacheManager {
  final LoginRepositories _repository = LoginRepositories(
    DioModule.getInstance(),
  );
  ParentResponse? response = ParentResponse();

  /// Call login API with email and password
  Future<LoginDataModel?> loginUser(LoginDataRequest request) async {
    try {
      LoginDataModel dataModel = LoginDataModel();
      response = await _repository.loginUser(request);
      bool success = response?.success ?? false;
      debugPrint(
        "log-doLogin-response-LoginBl(1): ${json.encode(response?.data)}",
      );
      if (success) {
        dataModel = response?.data;
        debugPrint(
          "log-doLogin-response-LoginBl(2): ${json.encode(dataModel)}",
        );
        // Save token if exists in response

        if (dataModel != null && dataModel.access_token != null) {
          await saveAuthToken(dataModel.access_token ?? '');
        }
        // Save user data if exists in response
        if (dataModel != null) {
          await saveUserData(dataModel);
        }
        // Save authentication data to cache
        await saveLoginStatus(true);
      } else {
        throw Exception(response?.message ?? 'Login failed!!!');
      }
      return dataModel;
    } catch (e) {
      debugPrint(
        "log-doLogin-response-LoginBl(1): ${json.encode(e.toString())}",
      );
      rethrow;
    }
  }

  Future<String> logout() async {
    try {
      LoginDataModel dataModel = LoginDataModel();
      dataModel = await getUserData();
      String token = dataModel.access_token ?? '';
      response = await _repository.logoutUser(token);
      bool success = response?.success ?? false;
      String message = response?.message ?? '';
      debugPrint(
        "log-doLogout-response-LoginBl(1): ${json.encode(response?.data)}",
      );
      if (success) {
        await clearAuthData();
        Get.snackbar("", message, snackPosition: SnackPosition.BOTTOM);
      } else {
        throw Exception(message);
      }
      return message;
    } catch (e) {
      debugPrint(
        "log-doLogout-response-LoginBl(1): ${json.encode(e.toString())}",
      );
      rethrow;
    }
  }

  Future<SessionDm> getSessionProduct(
    String key,
    String token,
    SessionDataRequest sessionDataRequest,
  ) async {
    try {
      SessionDm sessionDm = SessionDm();
      response = await _repository.getSessionProduct(
        key,
        token,
        sessionDataRequest,
      );
      bool success = response?.success ?? false;
      debugPrint(
        "log-doLogin-response-LoginBl(3): ${json.encode(response?.data)}",
      );
      if (success) {
        if (sessionDm != null) {
          await clearSessionData();
        }
        sessionDm = response?.data;
        debugPrint(
          "log-doLogin-response-LoginBl(2): ${json.encode(sessionDm)}",
        );
        // Save user data if exists in response
        if (sessionDm != null) {
          await saveSessionData(sessionDm);
        }
      } else {
        throw Exception(response?.message ?? 'Login failed!!!');
      }
      return sessionDm;
    } catch (e) {
      debugPrint(
        "log-doLogin-response-LoginBl(4): ${json.encode(e.toString())}",
      );
      rethrow;
    }
  }
}
