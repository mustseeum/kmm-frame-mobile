import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:kacamatamoo/core/utilities/request_helper.dart';

import 'base_result.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

import 'base_result_error.dart';

class BaseRepo {
  final dio.Dio _dio;

  BaseRepo(this._dio) {
    // Allow 2xx, 302, and 401 status codes
    _dio.options.validateStatus = (status) {
      return (status != null && status >= 200 && status < 300) ||
          status == 302 ||
          status == 400 ||
          status == 401 ||
          status == 402 ||
          status == 403 ||
          status == 404 ||
          status == 406 ||
          status == 409 ||
          status == 500;
    };
  }

  /// Calls the API and returns a [BaseResult] with the response data.
  Future<BaseResult<T>> callApi<T>(
    Future<dio.Response<T>> Function() call, {
    bool isolate = false,
    bool showErrorDialogue = true,
  }) async {
    if (isolate) {
      return await _processInIsolate<T>(call);
    } else {
      return await _callApiDirectly<T>(
        call(),
        showErrorDialogue: showErrorDialogue,
      );
    }
  }

  Future<BaseResult<T>> _callApiDirectly<T>(
    Future<dio.Response<T>> call, {
    bool showErrorDialogue = true,
  }) async {
    try {
      final response = await call;

      // Handle 301/302 Redirection
      if (response.statusCode == 301 || response.statusCode == 302) {
        final location = response.headers['location']?.first;
        if (location != null) {
          return BaseResult.redirection(location);
        } else {
          return BaseResult.failed(
            message: 'Redirection failed: Location header missing',
          );
        }
      }

      // Handle 2xx Success
      if ((response.statusCode ?? 0) ~/ 100 == 2) {
        return BaseResult.success(response.data as T);
      }

      // Handle 422 Unprocessable Entity
      if (response.statusCode == 422) {
        final errorDetails = response
            .data; // Assuming the server provides error details in JSON format
        return BaseResult.unprocessableEntity(
          errorDetails.toString(),
          errorDetails,
        );
      }

      // Handle 401 Unauthorized
      if (response.statusCode == 401) {
        final errorDetails = response.data;
        final message = (response.data as Map<String, dynamic>)['message'];
        final status_code =
            (response.data as Map<String, dynamic>)['status_code'];
        debugPrint("json-login-Unauthorized: ${json.encode(message)}");
        debugPrint("json-login-Unauthorized: ${json.encode(status_code)}");
        if (status_code != 500) {
          await RequestHelper().unAuthenticated(response.statusCode, message);
          return BaseResult.unauthenticated(
            response.statusMessage,
            errorDetails,
          );
        } else {
          await RequestHelper().showError(message);
          return BaseResult.failed(message: message, data: errorDetails);
        }
      }

      if (response.statusCode == 406) {
        final errorDetails = response.data;
        final message = (response.data as Map<String, dynamic>)['message'];
        await RequestHelper().apiLevelNotMatch(message);
        return BaseResult.unprocessableEntity(
          errorDetails.toString(),
          errorDetails,
        );
      }

      // Handle 400 - 403
      if (response.statusCode != null &&
          response.statusCode! >= 400 &&
          response.statusCode! <= 403) {
        final errorDetails = response.data;
        final message = (response.data as Map<String, dynamic>)['message'];
        print('400/403 $message');
        // await RequestHelper().apiLevelNotMatch(message);
        return BaseResult.failed(message: message, data: errorDetails);
      }

      // Handle 404 Not Found
      if (response.statusCode! == 404) {
        final errorDetails = response.data;
        final message = (response.data as Map<String, dynamic>)['message'];
        print('error: 404 $message');
        // await RequestHelper().apiLevelNotMatch(message);
        if (showErrorDialogue) {
          await RequestHelper().showError(message);
        }
        return BaseResult.failed(message: message, data: errorDetails);
      }

      // Handle 409
      if (response.statusCode! == 409) {
        final errorDetails = response.data;
        final message = (response.data as Map<String, dynamic>)['message'];
        print('error: 409 $message');
        // Show the error message in a dialog
        if (showErrorDialogue) {
          await RequestHelper().showError(message);
        }
        return BaseResult.failed(message: message, data: errorDetails);
      }

      // Handle 500 Internal Server Error
      if (response.statusCode == 500) {
        final errorDetails = response.data;
        String errorMessage = "Internal Server Error";
        if (errorDetails is Map<String, dynamic> &&
            errorDetails.containsKey('message')) {
          errorMessage = errorDetails['message'] as String? ?? errorMessage;
        }

        // Log the error for debugging
        debugPrint("500 Error: $errorMessage");

        // Show the error message in a dialog
        if (showErrorDialogue) {
          await RequestHelper().showError(errorMessage);
        }

        return BaseResult.failed(message: errorMessage, data: errorDetails);
      }

      if (response.statusCode == 503) {
        final errorDetails = response.data;
        String errorMessage =
            (response.data as Map<String, dynamic>)['message'];
        if (errorDetails is Map<String, dynamic> &&
            errorDetails.containsKey('message')) {
          errorMessage = errorDetails['message'] as String? ?? errorMessage;
        }

        // Log the error for debugging
        debugPrint("500 Error: $errorMessage");

        // Show the error message in a dialog
        if (showErrorDialogue) {
          await RequestHelper().showError(errorMessage);
        }

        return BaseResult.failed(message: errorMessage, data: errorDetails);
      }

      // Handle other non-2xx responses
      return BaseResult.failed(
        message: response.data?.toString() ?? 'Unknown Error',
      );
    } on DioException catch (e) {
      // Handle network errors
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.sendTimeout) {
        return BaseResult.timeout("Network Failure");
      } else if (e.type == DioExceptionType.cancel) {
        debugPrint("Request cancelled");
        return BaseResult.requestCanceled();
      } else if (e.type == DioExceptionType.badResponse) {
        final errorDetails = e.response?.data;
        String errorMessage = errorDetails['message'];
        await RequestHelper().showError(errorMessage);
        return BaseResult.failed(message: errorMessage, data: errorDetails);
      } else {
        // Handle response errors
        try {
          BaseRespError error = BaseRespError.fromJson(e.response?.data);
          return BaseResult.failed(
            message:
                error.detail ??
                error.error?.message ??
                error.msg ??
                'Invalid response',
          );
        } catch (er) {
          return BaseResult.failed(
            message: e.response?.data?.toString() ?? "Connection Failed",
          );
        }
      }
    } catch (e) {
      return BaseResult.failed(message: e.toString());
    }
  }

  Future<BaseResult<T>> _processInIsolate<T>(
    Future<dio.Response<T>> Function() call,
  ) async {
    return await compute(_computeEntryPoint<T>, call);
  }

  static Future<BaseResult<T>> _computeEntryPoint<T>(
    Future<dio.Response<T>> Function() call,
  ) async {
    try {
      final response = await call();
      return BaseResult.success(
        {'data': response.data, 'realUri': response.realUri.toString()} as T,
      );
    } catch (e) {
      return BaseResult.failed(message: e.toString());
    }
  }

  Future<BaseResult<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    bool isolate = false,
    bool showErrorDialogue = true,
  }) async {
    return await callApi<T>(
      () => _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: dio.Options(headers: headers),
      ),
      isolate: isolate,
    );
  }

  Future<BaseResult<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? headers,
    dynamic body,
    bool isolate = false,
    bool showErrorDialogue = true,
  }) async {
    return await callApi<T>(
      () => _dio.post<T>(
        endpoint,
        data: body,
        options: dio.Options(headers: headers),
      ),
      isolate: isolate,
      showErrorDialogue: showErrorDialogue,
    );
  }

  Future<BaseResult<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? headers,
    dynamic body,
    bool isolate = false,
    bool showErrorDialogue = true,
  }) async {
    return await callApi<T>(
      () => _dio.delete<T>(
        endpoint,
        data: body,
        options: dio.Options(headers: headers),
      ),
      isolate: isolate,
    );
  }

  Future<BaseResult<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? headers,
    dynamic body,
    bool isolate = false,
    bool showErrorDialogue = true,
  }) async {
    return await callApi<T>(
      () => _dio.put<T>(
        endpoint,
        data: body,
        options: dio.Options(headers: headers),
      ),
      isolate: isolate,
    );
  }

  Future<BaseResult<T>> postMultipart<T>(
    String endpoint, {
    Map<String, String>? headers,
    dio.FormData? body,
    bool isolate = false,
    bool showErrorDialogue = true,
  }) async {
    return await callApi<T>(
      () => _dio.post<T>(
        endpoint,
        data: body,
        options: dio.Options(headers: headers),
      ),
      isolate: isolate,
    );
  }
}
