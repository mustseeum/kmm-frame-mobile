import 'package:dio/dio.dart';
import 'package:kacamatamoo/data/cache/cache_manager.dart';

class ApiInterceptor extends Interceptor with CacheManager {
  String token = "";
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // if (options.headers['Authorization'] == null) {
    //   LoginDm _loginDM = await getLoginData();
    //   token = _loginDM.accessToken ?? "";
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
