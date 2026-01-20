import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kacamatamoo/core/base/http_connection/base_repo.dart';
import 'package:kacamatamoo/core/base/http_connection/base_result.dart';
import 'package:kacamatamoo/core/constants/api_constants.dart';
import 'package:kacamatamoo/core/network/models/parent_response.dart';
import 'package:kacamatamoo/core/utilities/request_helper.dart';
import 'package:kacamatamoo/data/models/data_response/privacy_policies/privacy_policies_dm.dart';

class PrivacyPoliciesRepository extends BaseRepo {
  PrivacyPoliciesRepository(super.dio);
  final String pageId = (PrivacyPoliciesRepository).toString();

  Future<ParentResponse?> fetchPrivacyPolicies(
    String token,
    String lang,
  ) async {
    String endPoint = ApiConstants.privacyPoliciesActive;
    ParentResponse? parent;
    // execute API
    BaseResult? response;
    response = await get(
      endPoint,
      headers: {'Authorization': 'Bearer $token', 'User-Language': lang},
    );
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
        final PrivacyPoliciesDm dataModel = PrivacyPoliciesDm.fromJson(
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
