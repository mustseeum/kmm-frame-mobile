import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kacamatamoo/core/network/dio_module.dart';
import 'package:kacamatamoo/core/network/models/parent_response.dart';
import 'package:kacamatamoo/data/cache/cache_manager.dart';
import 'package:kacamatamoo/data/models/data_response/login/data_user.dart';
import 'package:kacamatamoo/data/models/data_response/login/login_data_model.dart';
import 'package:kacamatamoo/data/models/request/login_data_request.dart';
import 'package:kacamatamoo/data/repositories/auth/login_repositories.dart';

class LoginBl with CacheManager {
  final LoginRepositories _repository = LoginRepositories(
    DioModule.getInstance(),
  );

  /// Call login API with email and password
  Future<LoginDataModel?> loginUser(LoginDataRequest request) async {
    try {
      LoginDataModel dataModel = LoginDataModel();
      final ParentResponse? response = await _repository.loginUser(request);
      bool success = response?.success ?? false;
      debugPrint("log-doLogin-response-LoginBl(1): ${json.encode(response)}");
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
}
