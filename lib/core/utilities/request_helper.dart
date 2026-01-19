import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/http_connection/base_result.dart';
import 'package:kacamatamoo/core/network/models/parent_response.dart';
import 'package:kacamatamoo/data/cache/cache_manager.dart';

class RequestHelper with CacheManager {

  Future<ParentResponse?> generateErrorResponse(String message) async {
    ParentResponse parentResponse = ParentResponse();
    parentResponse.message = message;
    return parentResponse;
  }

  Future<ParentResponse?> responseHandler({
    BaseResult? response,
    required Function onSuccess,
    required Function onRedirection,
    required Function onUnprocessableEntity,
    required Function onError,
    required Function onUnreachable,
    required Function onDefault,
    required Function unauthenticated,
  }) async {
    // bool useDummy = await getUseDummy();
    // if (useDummy) {
    // return onSuccess();
    // } else {
    switch (response?.status) {
      case ResponseStatus.Success:
        return onSuccess();
      case ResponseStatus.unauthenticated:
        return unauthenticated();
      case ResponseStatus.Error:
        return onError();
      case ResponseStatus.Unreachable:
        return onUnreachable();
      default:
        return onDefault();
    }
    // }
  }

  Future<bool> unAuthenticated(int? statusCode, String? statusMessage) async {
    if (statusCode == 401) {
      debugPrint("Unauthorized User - $statusMessage");
      return true;
    }
    return false;
  }

  Future<bool> apiLevelNotMatch(String message) async {
    Get.dialog(
      AlertDialog(
        title: Text("Halo !"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              // Navigation.goBack();
              // await Helpers().doLogout();
            },
            child: Text("Update"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return true;
  }

  Future<bool> showError(String errorMessage) async {
    String message = errorMessage.capitalize ?? "Silahkan hubungi admin";
    Get.dialog(
      AlertDialog(
        title: Text("Ooops !"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("OK"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return true;
  }
}
