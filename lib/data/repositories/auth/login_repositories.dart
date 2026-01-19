import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kacamatamoo/core/base/http_connection/base_repo.dart';
import 'package:kacamatamoo/core/base/http_connection/base_result.dart';
import 'package:kacamatamoo/core/constants/api_constants.dart';
import 'package:kacamatamoo/core/network/models/parent_response.dart';
import 'package:kacamatamoo/core/utils/request_helper.dart';
import 'package:kacamatamoo/data/cache/cache_manager.dart';
import 'package:kacamatamoo/data/models/data_response/login/login_data_model.dart';
import 'package:kacamatamoo/data/models/request/login_data_request.dart';

class LoginRepositories extends BaseRepo with CacheManager {
  LoginRepositories(super.dio);
  String pageId = (LoginRepositories).toString();

  Future<ParentResponse?> loginUser(LoginDataRequest loginDataRequest) async {
    String endPoint = ApiConstants.login;
    ParentResponse? parent;
    // execute API
    BaseResult? response;
    response = await post(endPoint, body: loginDataRequest);
    debugPrint(
      "$pageId(1)-log-doLogin-response: ${json.encode(response.data)}",
    );

    try {
      parent = ParentResponse.fromJson(response.data);
      debugPrint("$pageId(2)-log-doLogin-response: ${json.encode(parent)}");
    } catch (e) {
      debugPrint(
        "$pageId(3)-log-doLogin-response: ${json.encode(e.toString())}",
      );
      rethrow;
    }

    return RequestHelper().responseHandler(
      response: response,
      onSuccess: () {
        final LoginDataModel dataModel = LoginDataModel.fromJson(
          parent?.data ?? {},
        );
        parent?.data = dataModel;
        return parent;
      },
      onRedirection: () {
        return RequestHelper().generateErrorResponse(
          response?.errorMessage ?? "",
        );
      },
      onUnprocessableEntity: () {
        return RequestHelper().generateErrorResponse(
          response?.errorMessage ?? "",
        );
      },
      onError: () {
        return RequestHelper().generateErrorResponse(
          response?.errorMessage ?? "",
        );
      },
      onUnreachable: () {
        return RequestHelper().generateErrorResponse(
          response?.errorMessage ?? "",
        );
      },
      onDefault: () {
        return RequestHelper().generateErrorResponse(
          response?.errorMessage ?? "",
        );
      },
      unauthenticated: () {
        return RequestHelper().generateErrorResponse(
          response?.errorMessage ?? "",
        );
      },
    );
  }
}
