import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kacamatamoo/core/base/http_connection/base_repo.dart';
import 'package:kacamatamoo/core/base/http_connection/base_result.dart';
import 'package:kacamatamoo/core/constants/api_constants.dart';
import 'package:kacamatamoo/core/network/models/parent_response.dart';
import 'package:kacamatamoo/core/utilities/request_helper.dart';
import 'package:kacamatamoo/data/models/request/questionnaire/answers_data_request.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/ml_scan_processing_dm.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

class MLScanProcessingRepository extends BaseRepo {
  MLScanProcessingRepository(super.dio);

  Future<ParentResponse?> processFaceScan(
    AnswersDataRequest answers,
    String token,
  ) async {
    String endpoint = ApiConstants.mlScanProcessingEndpoint;
    ParentResponse? response;
    BaseResult? apiResponse;
    FormData formData = FormData();
    // formData = await answers.toFormData();
    formData = FormData.fromMap({
      "answers": json.encode(answers.answers?.toJson()),
      if (answers.image != null && answers.image != "")
        "image": await MultipartFile.fromFile(
          answers.image?.path ?? "",
          filename: basename(answers.image!.path.split('/').last),
        ),
    });

    apiResponse = await post(
      endpoint,
      body: formData,
      headers: {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      },
    );
    debugPrint(
      "MLScanProcessingRepository-log-processFaceScan-response(1): ${json.encode(apiResponse.data)}",
    );
    try {
      response = ParentResponse.fromJson(apiResponse.data);
      debugPrint(
        "MLScanProcessingRepository-log-processFaceScan-parentResponse(2): ${json.encode(response)}",
      );
    } catch (e) {
      debugPrint(
        "MLScanProcessingRepository-log-processFaceScan-error: ${json.encode(e.toString())}",
      );
      rethrow;
    }
    return RequestHelper().responseHandler(
      response: apiResponse,
      onSuccess: () {
        debugPrint(
          "MLScanProcessingRepository-log-processFaceScan-dataModel(3): ${json.encode(response?.data)}",
        );
        final MLScanProcessingDm dataModel = MLScanProcessingDm.fromJson(
          response?.data ?? {},
        );
        debugPrint(
          "MLScanProcessingRepository-log-processFaceScan-dataModel(4): ${json.encode(dataModel)}",
        );
        response?.data = dataModel;
        return response;
      },
      onRedirection: () {
        return RequestHelper().generateErrorResponse(
          apiResponse?.errorMessage ?? "",
        );
      },
      onUnprocessableEntity: () {
        return RequestHelper().generateErrorResponse(
          apiResponse?.errorMessage ?? "",
        );
      },
      onError: () {
        return RequestHelper().generateErrorResponse(
          apiResponse?.errorMessage ?? "",
        );
      },
      onUnreachable: () {
        return RequestHelper().generateErrorResponse(
          apiResponse?.errorMessage ?? "",
        );
      },
      onDefault: () {
        return RequestHelper().generateErrorResponse(
          apiResponse?.errorMessage ?? "",
        );
      },
      unauthenticated: () {
        return RequestHelper().generateErrorResponse(
          apiResponse?.errorMessage ?? "",
        );
      },
    );
  }
}
