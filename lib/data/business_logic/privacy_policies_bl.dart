import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kacamatamoo/core/network/dio_module.dart';
import 'package:kacamatamoo/core/network/models/parent_response.dart';
import 'package:kacamatamoo/data/cache/cache_manager.dart';
import 'package:kacamatamoo/data/models/data_response/login/login_data_model.dart';
import 'package:kacamatamoo/data/models/data_response/privacy_policies/privacy_policies_dm.dart';
import 'package:kacamatamoo/data/repositories/question_recommendation/privacy_policies_repository.dart';

class PrivacyPoliciesBl with CacheManager {
  final PrivacyPoliciesRepository _privacyPoliciesRepository =
      PrivacyPoliciesRepository(DioModule.getInstance());

  ParentResponse? response = ParentResponse();
  Future<PrivacyPoliciesDm> getPrivacyPolicies(String lang) async {
    try {
      LoginDataModel? cachedUserData = await getUserData();
      String token = cachedUserData.access_token ?? '';
      response = await _privacyPoliciesRepository.fetchPrivacyPolicies(
        token,
        lang,
      );
      bool isSuccess = response?.success ?? false;

      if (isSuccess) {
        PrivacyPoliciesDm privacyPoliciesDm = response?.data;
        debugPrint(
          "log-getPrivacyPolicies-response-PrivacyPoliciesBl(2): ${json.encode(privacyPoliciesDm)}",
        );
        return privacyPoliciesDm;
      } else {
        throw Exception(
          response?.message ?? 'Failed to fetch privacy policies',
        );
      }
    } catch (e) {
      debugPrint(
        "log-getPrivacyPolicies-response-PrivacyPoliciesBl(1): ${json.encode(e.toString())}",
      );
      rethrow;
    }
  }
}
