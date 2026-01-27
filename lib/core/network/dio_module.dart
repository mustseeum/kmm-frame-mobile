import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:kacamatamoo/core/config/app_environment.dart';

import 'api_interceptor.dart';
import 'log_interceptor.dart' as log;

class DioModule with DioMixin implements Dio {
  final AppEnvironment env = AppEnvironment();

  DioModule._() {
    options = BaseOptions(
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      followRedirects: true,
      receiveDataWhenStatusError: true,
      baseUrl: env.baseUrl(),
    );

    interceptors.add(ApiInterceptor());
    interceptors.add(log.LogInterceptor());
    interceptors.add(ChuckerDioInterceptor());

    httpClientAdapter = IOHttpClientAdapter();
  }

  static Dio getInstance() => DioModule._();
}
