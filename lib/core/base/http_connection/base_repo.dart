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
    // Allow 2xx, 3xx redirects, and specific error codes for custom handling
    _dio.options.validateStatus = (status) {
      return (status != null && status >= 200 && status < 300) ||
          status == 301 || // Moved Permanently
          status == 302 || // Found (Temporary Redirect)
          status == 400 || // Bad Request
          status == 401 || // Unauthorized
          status == 402 || // Payment Required
          status == 403 || // Forbidden
          status == 404 || // Not Found
          status == 405 || // Method Not Allowed
          status == 406 || // Not Acceptable
          status == 408 || // Request Timeout
          status == 409 || // Conflict
          status == 410 || // Gone
          status == 413 || // Payload Too Large
          status == 415 || // Unsupported Media Type
          status == 422 || // Unprocessable Entity
          status == 429 || // Too Many Requests
          status == 500 || // Internal Server Error
          status == 502 || // Bad Gateway
          status == 503 || // Service Unavailable
          status == 504 || // Gateway Timeout
          status == 521 || // Web Server Is Down (Cloudflare)
          status == 522 || // Connection Timed Out (Cloudflare)
          status == 523 || // Origin Is Unreachable (Cloudflare)
          status == 524 || // A Timeout Occurred (Cloudflare)
          status == 525 || // SSL Handshake Failed (Cloudflare)
          status == 530;   // Custom Server Error
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

      // Handle 400 Bad Request
      if (response.statusCode == 400) {
        final errorDetails = response.data;
        final message = (response.data as Map<String, dynamic>)['message'];
        debugPrint('400 Bad Request: $message');
        if (showErrorDialogue) {
          await RequestHelper().showError(message);
        }
        return BaseResult.failed(message: message, data: errorDetails);
      }

      // Handle 402 Payment Required
      if (response.statusCode == 402) {
        final errorDetails = response.data;
        final message = (response.data as Map<String, dynamic>)['message'];
        debugPrint('402 Payment Required: $message');
        if (showErrorDialogue) {
          await RequestHelper().showError(message);
        }
        return BaseResult.failed(message: message, data: errorDetails);
      }

      // Handle 403 Forbidden
      if (response.statusCode == 403) {
        final errorDetails = response.data;
        final message = (response.data as Map<String, dynamic>)['message'];
        debugPrint('403 Forbidden: $message');
        if (showErrorDialogue) {
          await RequestHelper().showError(message);
        }
        return BaseResult.failed(message: message, data: errorDetails);
      }

      // Handle 404 Not Found
      if (response.statusCode == 404) {
        final errorDetails = response.data;
        final message = (response.data as Map<String, dynamic>)['message'];
        debugPrint('404 Not Found: $message');
        if (showErrorDialogue) {
          await RequestHelper().showError(message);
        }
        return BaseResult.failed(message: message, data: errorDetails);
      }

      // Handle 405 Method Not Allowed
      if (response.statusCode == 405) {
        final errorDetails = response.data;
        final message = (response.data as Map<String, dynamic>)['message'];
        debugPrint('405 Method Not Allowed: $message');
        if (showErrorDialogue) {
          await RequestHelper().showError(message);
        }
        return BaseResult.failed(message: message, data: errorDetails);
      }

      // Handle 408 Request Timeout
      if (response.statusCode == 408) {
        final errorDetails = response.data;
        final message = (response.data as Map<String, dynamic>)['message'] ??
            'Request Timeout';
        debugPrint('408 Request Timeout: $message');
        if (showErrorDialogue) {
          await RequestHelper().showError(message);
        }
        return BaseResult.timeout(message);
      }

      // Handle 409 Conflict
      if (response.statusCode == 409) {
        final errorDetails = response.data;
        final message = (response.data as Map<String, dynamic>)['message'];
        debugPrint('409 Conflict: $message');
        if (showErrorDialogue) {
          await RequestHelper().showError(message);
        }
        return BaseResult.failed(message: message, data: errorDetails);
      }

      // Handle 410 Gone
      if (response.statusCode == 410) {
        final errorDetails = response.data;
        final message = (response.data as Map<String, dynamic>)['message'];
        debugPrint('410 Gone: $message');
        if (showErrorDialogue) {
          await RequestHelper().showError(message);
        }
        return BaseResult.failed(message: message, data: errorDetails);
      }

      // Handle 413 Payload Too Large
      if (response.statusCode == 413) {
        final errorDetails = response.data;
        final message = (response.data as Map<String, dynamic>)['message'] ??
            'Payload Too Large';
        debugPrint('413 Payload Too Large: $message');
        if (showErrorDialogue) {
          await RequestHelper().showError(message);
        }
        return BaseResult.failed(message: message, data: errorDetails);
      }

      // Handle 415 Unsupported Media Type
      if (response.statusCode == 415) {
        final errorDetails = response.data;
        final message = (response.data as Map<String, dynamic>)['message'] ??
            'Unsupported Media Type';
        debugPrint('415 Unsupported Media Type: $message');
        if (showErrorDialogue) {
          await RequestHelper().showError(message);
        }
        return BaseResult.failed(message: message, data: errorDetails);
      }

      // Handle 429 Too Many Requests
      if (response.statusCode == 429) {
        final errorDetails = response.data;
        final message = (response.data as Map<String, dynamic>)['message'] ??
            'Too Many Requests. Please try again later.';
        debugPrint('429 Too Many Requests: $message');
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

        debugPrint("500 Internal Server Error: $errorMessage");

        if (showErrorDialogue) {
          await RequestHelper().showError(errorMessage);
        }

        return BaseResult.failed(message: errorMessage, data: errorDetails);
      }

      // Handle 502 Bad Gateway
      if (response.statusCode == 502) {
        final errorDetails = response.data;
        String errorMessage = "Bad Gateway";
        if (errorDetails is Map<String, dynamic> &&
            errorDetails.containsKey('message')) {
          errorMessage = errorDetails['message'] as String? ?? errorMessage;
        }

        debugPrint("502 Bad Gateway: $errorMessage");

        if (showErrorDialogue) {
          await RequestHelper().showError(errorMessage);
        }

        return BaseResult.failed(message: errorMessage, data: errorDetails);
      }

      // Handle 503 Service Unavailable
      if (response.statusCode == 503) {
        final errorDetails = response.data;
        String errorMessage = "Service Unavailable";
        if (errorDetails is Map<String, dynamic> &&
            errorDetails.containsKey('message')) {
          errorMessage = errorDetails['message'] as String? ?? errorMessage;
        }

        debugPrint("503 Service Unavailable: $errorMessage");

        if (showErrorDialogue) {
          await RequestHelper().showError(errorMessage);
        }

        return BaseResult.failed(message: errorMessage, data: errorDetails);
      }

      // Handle 504 Gateway Timeout
      if (response.statusCode == 504) {
        final errorDetails = response.data;
        String errorMessage = "Gateway Timeout";
        if (errorDetails is Map<String, dynamic> &&
            errorDetails.containsKey('message')) {
          errorMessage = errorDetails['message'] as String? ?? errorMessage;
        }

        debugPrint("504 Gateway Timeout: $errorMessage");

        if (showErrorDialogue) {
          await RequestHelper().showError(errorMessage);
        }

        return BaseResult.timeout(errorMessage);
      }

      // Handle 521 Web Server Is Down (Cloudflare)
      if (response.statusCode == 521) {
        final errorDetails = response.data;
        String errorMessage = "Web Server Is Down";
        if (errorDetails is Map<String, dynamic> &&
            errorDetails.containsKey('message')) {
          errorMessage = errorDetails['message'] as String? ?? errorMessage;
        }

        debugPrint("521 Cloudflare - Web Server Is Down: $errorMessage");

        if (showErrorDialogue) {
          await RequestHelper().showError(errorMessage);
        }

        return BaseResult.failed(message: errorMessage, data: errorDetails);
      }

      // Handle 522 Connection Timed Out (Cloudflare)
      if (response.statusCode == 522) {
        final errorDetails = response.data;
        String errorMessage = "Connection Timed Out";
        if (errorDetails is Map<String, dynamic> &&
            errorDetails.containsKey('message')) {
          errorMessage = errorDetails['message'] as String? ?? errorMessage;
        }

        debugPrint("522 Cloudflare - Connection Timed Out: $errorMessage");

        if (showErrorDialogue) {
          await RequestHelper().showError(errorMessage);
        }

        return BaseResult.timeout(errorMessage);
      }

      // Handle 523 Origin Is Unreachable (Cloudflare)
      if (response.statusCode == 523) {
        final errorDetails = response.data;
        String errorMessage = "Origin Is Unreachable";
        if (errorDetails is Map<String, dynamic> &&
            errorDetails.containsKey('message')) {
          errorMessage = errorDetails['message'] as String? ?? errorMessage;
        }

        debugPrint("523 Cloudflare - Origin Is Unreachable: $errorMessage");

        if (showErrorDialogue) {
          await RequestHelper().showError(errorMessage);
        }

        return BaseResult.failed(message: errorMessage, data: errorDetails);
      }

      // Handle 524 A Timeout Occurred (Cloudflare)
      if (response.statusCode == 524) {
        final errorDetails = response.data;
        String errorMessage = "A Timeout Occurred";
        if (errorDetails is Map<String, dynamic> &&
            errorDetails.containsKey('message')) {
          errorMessage = errorDetails['message'] as String? ?? errorMessage;
        }

        debugPrint("524 Cloudflare - A Timeout Occurred: $errorMessage");

        if (showErrorDialogue) {
          await RequestHelper().showError(errorMessage);
        }

        return BaseResult.timeout(errorMessage);
      }

      // Handle 525 SSL Handshake Failed (Cloudflare)
      if (response.statusCode == 525) {
        final errorDetails = response.data;
        String errorMessage = "SSL Handshake Failed";
        if (errorDetails is Map<String, dynamic> &&
            errorDetails.containsKey('message')) {
          errorMessage = errorDetails['message'] as String? ?? errorMessage;
        }

        debugPrint("525 Cloudflare - SSL Handshake Failed: $errorMessage");

        if (showErrorDialogue) {
          await RequestHelper().showError(errorMessage);
        }

        return BaseResult.failed(message: errorMessage, data: errorDetails);
      }

      // Handle 530 Custom Server Error
      if (response.statusCode == 530) {
        final errorDetails = response.data;
        String errorMessage = "Server Error";
        if (errorDetails is Map<String, dynamic> &&
            errorDetails.containsKey('message')) {
          errorMessage = errorDetails['message'] as String? ?? errorMessage;
        }

        debugPrint("530 Custom Server Error: $errorMessage");

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
